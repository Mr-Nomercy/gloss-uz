import threading

from django.db import connections
from django.test import TransactionTestCase
from django.utils import timezone
from rest_framework.test import APIClient

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.orders.models import Order
from apps.tenants.models import Tenant
from apps.workforce.models import Team, WorkerProfile

from .models import DispatchQueue


def _make_worker_client(tenant, team):
    user = User.objects.create_user(phone=f"+99890{team.id:07d}")
    user.roles.create(role=Role.TENANT_WORKER, tenant=tenant)
    WorkerProfile.all_tenants.create(tenant=tenant, user=user, team=team)
    token = issue_token_for_role(user, "tenant_worker", tenant.id)
    client = APIClient()
    client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")
    return client


class AcceptOfferConcurrencyTests(TransactionTestCase):
    """M3 gate: two different teams accepting the same order at the same
    instant must resolve to exactly one winner. This needs real row
    locking (select_for_update/skip_locked), which only Postgres
    provides — this is precisely why M3 couldn't be verified on sqlite.
    """

    def setUp(self):
        self.tenant_a = Tenant.objects.create(
            name="Firma A", phone="+998900000001", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        self.tenant_b = Tenant.objects.create(
            name="Firma B", phone="+998900000002", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        self.team_a = Team.all_tenants.create(
            tenant=self.tenant_a, name="Team A", status=Team.Status.AVAILABLE
        )
        self.team_b = Team.all_tenants.create(
            tenant=self.tenant_b, name="Team B", status=Team.Status.AVAILABLE
        )

        customer = User.objects.create_user(phone="+998911111111")
        category = ServiceCategory.objects.create(name="Uy tozalash")
        tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        address = Address.objects.create(
            user=customer, raw_address="X", city="Toshkent", lat="41.311", lng="69.279"
        )
        self.order = Order.objects.create(
            customer=customer,
            tariff=tariff,
            address=address,
            scheduled_time=timezone.now() + timezone.timedelta(days=1),
            total_price="50000.00",
        )
        DispatchQueue.objects.create(order=self.order, team=self.team_a)
        DispatchQueue.objects.create(order=self.order, team=self.team_b)

    def test_only_one_team_wins_under_concurrent_accept(self):
        client_a = _make_worker_client(self.tenant_a, self.team_a)
        client_b = _make_worker_client(self.tenant_b, self.team_b)

        results = {}

        def accept(name, client):
            try:
                response = client.post(f"/api/v1/dispatch/orders/{self.order.id}/accept/")
                results[name] = response.status_code
            finally:
                connections.close_all()

        barrier_ready = threading.Barrier(2, timeout=5)

        def accept_synced(name, client):
            barrier_ready.wait()
            accept(name, client)

        t1 = threading.Thread(target=accept_synced, args=("a", client_a))
        t2 = threading.Thread(target=accept_synced, args=("b", client_b))
        t1.start()
        t2.start()
        t1.join()
        t2.join()

        status_codes = sorted(results.values())
        self.assertEqual(status_codes, [200, 409])

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.ASSIGNED)

        winners = DispatchQueue.objects.filter(order=self.order, is_winner=True)
        self.assertEqual(winners.count(), 1)

    def test_second_accept_after_first_commits_gets_409(self):
        client_a = _make_worker_client(self.tenant_a, self.team_a)
        client_b = _make_worker_client(self.tenant_b, self.team_b)

        response_a = client_a.post(f"/api/v1/dispatch/orders/{self.order.id}/accept/")
        response_b = client_b.post(f"/api/v1/dispatch/orders/{self.order.id}/accept/")

        self.assertEqual(response_a.status_code, 200)
        self.assertEqual(response_b.status_code, 409)

    def test_non_worker_role_is_rejected(self):
        customer = User.objects.create_user(phone="+998955555555")
        customer.roles.create(role=Role.CUSTOMER, tenant=None)
        token = issue_token_for_role(customer, "customer", None)
        client = APIClient()
        client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        response = client.post(f"/api/v1/dispatch/orders/{self.order.id}/accept/")

        self.assertEqual(response.status_code, 403)
