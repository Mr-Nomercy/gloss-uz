from decimal import Decimal

from django.utils import timezone
from rest_framework.test import APIClient, APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.notifications.models import Notification
from apps.tenants.models import CommissionRule, Tenant, Transaction, Wallet
from apps.workforce.models import Team, WorkerProfile

from .models import Order, Review


class FullCustomerWorkerLoopTests(APITestCase):
    """M4 gate: a customer's order goes all the way from booking to a
    rated, billed order, with the commission landing in the correct
    tenant wallet — the actual "close the loop" requirement.
    """

    def setUp(self):
        self.tenant = Tenant.objects.create(
            name="Firma A", phone="+998900000001", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        self.team = Team.all_tenants.create(
            tenant=self.tenant, name="Team A", status=Team.Status.AVAILABLE
        )

        self.worker_user = User.objects.create_user(phone="+998911111111", full_name="Ishchi")
        self.worker_user.roles.create(role=Role.TENANT_WORKER, tenant=self.tenant)
        WorkerProfile.all_tenants.create(tenant=self.tenant, user=self.worker_user, team=self.team)
        worker_token = issue_token_for_role(self.worker_user, "tenant_worker", self.tenant.id)
        self.worker_client = APIClient()
        self.worker_client.credentials(HTTP_AUTHORIZATION=f"Bearer {worker_token.access_token}")

        self.customer = User.objects.create_user(phone="+998922222222", full_name="Mijoz")
        self.customer.roles.create(role=Role.CUSTOMER, tenant=None)
        customer_token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {customer_token.access_token}")

        category = ServiceCategory.objects.create(name="Uy tozalash")
        self.tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="100000.00", duration_min=180
        )
        address = Address.objects.create(
            user=self.customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = Order.objects.create(
            customer=self.customer,
            tenant=self.tenant,
            team=self.team,
            tariff=self.tariff,
            address=address,
            status=Order.Status.ASSIGNED,
            scheduled_time=timezone.now() + timezone.timedelta(hours=1),
            total_price="100000.00",
        )

    def _worker_advance(self, expected_status):
        return self.worker_client.patch(
            f"/api/v1/worker/orders/{self.order.id}/status/", {"status": expected_status}
        )

    def test_full_loop_bills_platform_default_commission(self):
        for expected in ["en_route", "arrived", "in_progress", "completed"]:
            response = self._worker_advance(expected)
            self.assertEqual(response.status_code, 200, response.data)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.COMPLETED)
        self.assertEqual(self.order.commission_amount, Decimal("15000.00"))
        self.assertEqual(self.order.net_amount, Decimal("85000.00"))

        wallet = Wallet.objects.get(tenant=self.tenant)
        self.assertEqual(wallet.balance, Decimal("85000.00"))

        transaction = Transaction.objects.get(order=self.order)
        self.assertEqual(transaction.type, Transaction.Type.COMMISSION_CREDIT)
        self.assertEqual(transaction.amount, Decimal("85000.00"))

        self.assertTrue(
            Notification.objects.filter(user=self.customer, title="Buyurtma tugallandi").exists()
        )

        rate_response = self.client.post(
            f"/api/v1/orders/{self.order.id}/rate/",
            {
                "aspectQuality": 5,
                "aspectPunctuality": 4,
                "aspectCommunication": 5,
                "comment": "Yaxshi",
            },
        )
        self.assertEqual(rate_response.status_code, 201, rate_response.data)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.RATED)

        self.team.refresh_from_db()
        self.assertEqual(self.team.rating_avg, Decimal("4.67"))

    def test_tenant_specific_commission_rule_overrides_platform_default(self):
        CommissionRule.objects.create(service_type="Uy tozalash", percentage="10.00", tenant=None)
        CommissionRule.objects.create(
            service_type="Uy tozalash", percentage="20.00", tenant=self.tenant
        )

        for expected in ["en_route", "arrived", "in_progress", "completed"]:
            self._worker_advance(expected)

        self.order.refresh_from_db()
        self.assertEqual(self.order.commission_amount, Decimal("20000.00"))

    def test_commission_falls_back_to_tenant_flat_rate_with_no_matching_rule(self):
        self.tenant.commission_rate = Decimal("0.30")
        self.tenant.save(update_fields=["commission_rate"])

        for expected in ["en_route", "arrived", "in_progress", "completed"]:
            self._worker_advance(expected)

        self.order.refresh_from_db()
        self.assertEqual(self.order.commission_amount, Decimal("30000.00"))

    def test_worker_cannot_skip_a_status(self):
        response = self._worker_advance("completed")

        self.assertEqual(response.status_code, 400)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.ASSIGNED)

    def test_worker_from_a_different_team_cannot_update_order(self):
        other_tenant = Tenant.objects.create(
            name="Firma B", phone="+998900000003", city="Samarqand"
        )
        other_team = Team.all_tenants.create(
            tenant=other_tenant, name="Team B", status=Team.Status.AVAILABLE
        )
        other_worker = User.objects.create_user(phone="+998933333333", full_name="Boshqa ishchi")
        other_worker.roles.create(role=Role.TENANT_WORKER, tenant=other_tenant)
        WorkerProfile.all_tenants.create(tenant=other_tenant, user=other_worker, team=other_team)
        other_token = issue_token_for_role(other_worker, "tenant_worker", other_tenant.id)
        other_client = APIClient()
        other_client.credentials(HTTP_AUTHORIZATION=f"Bearer {other_token.access_token}")

        response = other_client.patch(
            f"/api/v1/worker/orders/{self.order.id}/status/", {"status": "en_route"}
        )

        self.assertEqual(response.status_code, 403)

    def test_cannot_rate_before_completed(self):
        response = self.client.post(
            f"/api/v1/orders/{self.order.id}/rate/",
            {"aspectQuality": 5, "aspectPunctuality": 5, "aspectCommunication": 5},
        )

        self.assertEqual(response.status_code, 400)

    def test_cannot_rate_twice(self):
        for expected in ["en_route", "arrived", "in_progress", "completed"]:
            self._worker_advance(expected)

        first = self.client.post(
            f"/api/v1/orders/{self.order.id}/rate/",
            {"aspectQuality": 5, "aspectPunctuality": 5, "aspectCommunication": 5},
        )
        self.assertEqual(first.status_code, 201)

        second = self.client.post(
            f"/api/v1/orders/{self.order.id}/rate/",
            {"aspectQuality": 1, "aspectPunctuality": 1, "aspectCommunication": 1},
        )
        self.assertEqual(second.status_code, 400)
        self.assertEqual(Review.objects.filter(order=self.order).count(), 1)
