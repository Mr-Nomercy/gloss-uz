from django.urls import reverse
from rest_framework.test import APITestCase

from apps.accounts.models import User
from apps.accounts.tokens import issue_token_for_role
from apps.tenants.models import Tenant

from .models import Team, WorkerProfile


class TenantIsolationTests(APITestCase):
    """M1 gate: tenant A must never see tenant B's data, even though
    both are served by the same endpoint with the same query code path.
    """

    def setUp(self):
        self.tenant_a = Tenant.objects.create(
            name="Firma A", phone="+998900000001", city="Toshkent"
        )
        self.tenant_b = Tenant.objects.create(
            name="Firma B", phone="+998900000002", city="Samarqand"
        )

        self.team_a = Team.all_tenants.create(tenant=self.tenant_a, name="Team A")
        self.team_b = Team.all_tenants.create(tenant=self.tenant_b, name="Team B")

        self.worker_a_user = User.objects.create_user(phone="+998911111111")
        self.worker_b_user = User.objects.create_user(phone="+998922222222")

        self.worker_a = WorkerProfile.all_tenants.create(
            tenant=self.tenant_a, user=self.worker_a_user, team=self.team_a
        )
        self.worker_b = WorkerProfile.all_tenants.create(
            tenant=self.tenant_b, user=self.worker_b_user, team=self.team_b
        )

    def _auth(self, user, role, tenant_id):
        token = issue_token_for_role(user, role, tenant_id)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

    def test_tenant_admin_sees_only_own_workers(self):
        self._auth(self.worker_a_user, "tenant_admin", self.tenant_a.id)

        response = self.client.get(reverse("worker-profile-list"))

        self.assertEqual(response.status_code, 200)
        returned_ids = {item["id"] for item in response.data["results"]}
        self.assertEqual(returned_ids, {self.worker_a.id})
        self.assertNotIn(self.worker_b.id, returned_ids)

    def test_other_tenant_gets_zero_rows_not_an_error(self):
        self._auth(self.worker_b_user, "tenant_admin", self.tenant_b.id)

        response = self.client.get(reverse("worker-profile-list"))

        self.assertEqual(response.status_code, 200)
        returned_ids = {item["id"] for item in response.data["results"]}
        self.assertEqual(returned_ids, {self.worker_b.id})

    def test_no_tenant_in_token_returns_empty_not_everything(self):
        self._auth(self.worker_a_user, "customer", None)

        response = self.client.get(reverse("worker-profile-list"))

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["results"], [])

    def test_manager_default_never_leaks_across_tenants_directly(self):
        from apps.core.context import set_current_tenant_id

        set_current_tenant_id(self.tenant_a.id)
        try:
            ids = set(WorkerProfile.objects.values_list("id", flat=True))
            self.assertEqual(ids, {self.worker_a.id})
        finally:
            set_current_tenant_id(None)
