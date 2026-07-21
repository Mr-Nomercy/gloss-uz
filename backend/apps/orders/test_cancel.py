from django.utils import timezone
from rest_framework.test import APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.dispatch.models import DispatchQueue
from apps.tenants.models import Tenant
from apps.workforce.models import Team

from .models import Order


class OrderCancelGuardTests(APITestCase):
    def setUp(self):
        self.customer = User.objects.create_user(phone="+998911111111")
        self.customer.roles.create(role=Role.CUSTOMER, tenant=None)
        token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        category = ServiceCategory.objects.create(name="Uy tozalash")
        tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        address = Address.objects.create(
            user=self.customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = Order.objects.create(
            customer=self.customer,
            tariff=tariff,
            address=address,
            scheduled_time=timezone.now() + timezone.timedelta(days=1),
            total_price="50000.00",
        )

    def _cancel(self, reason=None):
        data = {"reason": reason} if reason else {}
        return self.client.post(f"/api/orders/{self.order.id}/cancel/", data)

    def test_searching_cancels_without_reason(self):
        response = self._cancel()
        self.assertEqual(response.status_code, 200)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.CANCELLED)

    def test_assigned_requires_reason(self):
        self.order.status = Order.Status.ASSIGNED
        self.order.save()

        response = self._cancel()
        self.assertEqual(response.status_code, 400)

        response = self._cancel(reason="Reja o'zgardi")
        self.assertEqual(response.status_code, 200)

    def test_in_progress_cannot_be_cancelled_by_customer(self):
        self.order.status = Order.Status.IN_PROGRESS
        self.order.save()

        response = self._cancel(reason="anything")

        self.assertEqual(response.status_code, 403)

    def test_in_progress_can_be_cancelled_by_platform_admin(self):
        self.order.status = Order.Status.IN_PROGRESS
        self.order.save()

        admin = User.objects.create_user(phone="+998900000099")
        admin.roles.create(role=Role.PLATFORM_ADMIN, tenant=None)
        admin_token = issue_token_for_role(admin, "platform_admin", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {admin_token.access_token}")

        response = self._cancel(reason="admin override")

        self.assertEqual(response.status_code, 200)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.CANCELLED)

    def test_completed_cannot_be_cancelled(self):
        self.order.status = Order.Status.COMPLETED
        self.order.save()

        response = self._cancel(reason="too late")

        self.assertEqual(response.status_code, 400)

    def test_cancel_marks_pending_offers_as_timeout(self):
        tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")
        team = Team.all_tenants.create(tenant=tenant, name="Team A", status=Team.Status.AVAILABLE)
        offer = DispatchQueue.objects.create(order=self.order, team=team)

        self._cancel()

        offer.refresh_from_db()
        self.assertEqual(offer.status, DispatchQueue.Status.TIMEOUT)
