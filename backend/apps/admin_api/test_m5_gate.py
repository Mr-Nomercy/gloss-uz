from unittest.mock import patch

from django.utils import timezone
from rest_framework.test import APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.orders.models import Order
from apps.tenants.models import Tenant
from apps.workforce.models import Team, WorkerProfile


class M5OnboardingGateTests(APITestCase):
    """M5 gate (docs/12-END-TO-END-ROADMAP.md): platform_admin creates a
    firm -> that firm's tenant_admin logs in -> generates an invite code
    -> a worker registers with it -> a customer's order gets accepted by
    that worker's team, all through the real API (no mocks besides the
    OTP provider, same as apps.accounts.test_auth_flow).

    Team membership has no admin-facing API yet (out of scope for this
    pass — see apps/workforce/views.py's WorkerProfileViewSet, which is
    still read-only), so that one step is done directly via the ORM,
    matching the precedent in apps.dispatch.test_accept_offer.
    """

    def _sent_code(self, mock_send):
        # ConsoleOtpProvider logs the code rather than returning it.
        return mock_send.call_args.args[1]

    @patch("apps.dispatch.tasks.expire_offer_round.apply_async")
    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_onboarding_to_accepted_order(self, mock_send, mock_apply_async):
        # --- platform_admin creates the firm ---
        admin = User.objects.create_user(phone="+998900000099", email="root@gloss.uz")
        admin.set_password("root12345")
        admin.save()
        admin.roles.create(role=Role.PLATFORM_ADMIN, tenant=None)
        admin_token = issue_token_for_role(admin, "platform_admin", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {admin_token.access_token}")

        tenant_phone = "+998901234567"
        create_response = self.client.post(
            "/api/v1/admin/tenants",
            {"company_name": "Tozalash Servis", "phone": tenant_phone, "city": "Toshkent"},
        )
        self.assertEqual(create_response.status_code, 201, create_response.data)
        tenant = Tenant.objects.get(id=create_response.json()["id"])

        tenant_admin_user = User.objects.get(phone=tenant_phone)
        self.assertEqual(tenant_admin_user.roles.get().role, Role.TENANT_ADMIN)

        # --- tenant_admin logs in (phone+OTP, same flow as every other
        # non-platform-admin role — see AdminLoginView's docstring) ---
        self.client.credentials()
        send_response = self.client.post(
            "/api/v1/auth/otp/send/", {"phone": tenant_phone, "channel": "sms"}
        )
        self.assertEqual(send_response.status_code, 200)
        code = self._sent_code(mock_send)

        verify_response = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": tenant_phone, "code": code}
        )
        self.assertEqual(verify_response.status_code, 200, verify_response.data)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {verify_response.data['access']}")

        # --- tenant_admin issues an invite code ---
        invite_response = self.client.post("/api/v1/invite-codes")
        self.assertEqual(invite_response.status_code, 201, invite_response.data)
        invite_code = invite_response.json()["code"]

        # --- worker registers with the invite code ---
        self.client.credentials()
        worker_phone = "+998907654321"
        self.client.post("/api/v1/auth/otp/send/", {"phone": worker_phone, "channel": "sms"})
        worker_code = self._sent_code(mock_send)
        worker_verify = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": worker_phone, "code": worker_code}
        )
        self.assertEqual(worker_verify.status_code, 200, worker_verify.data)

        register_response = self.client.post(
            "/api/v1/auth/worker/register/",
            {
                "verified_token": worker_verify.data["verified_token"],
                "invite_code": invite_code,
                "full_name": "Ishchi Bir",
            },
        )
        self.assertEqual(register_response.status_code, 201, register_response.data)

        worker_user = User.objects.get(phone=worker_phone)
        worker_profile = WorkerProfile.all_tenants.get(user=worker_user)
        self.assertEqual(worker_profile.tenant_id, tenant.id)

        # --- team membership: no admin API for this yet, assign directly ---
        team = Team.all_tenants.create(
            tenant=tenant,
            name="Team 1",
            status=Team.Status.AVAILABLE,
            location="POINT(69.279 41.311)",
        )
        worker_profile.team = team
        worker_profile.save(update_fields=["team"])

        tenant.status = Tenant.Status.ACTIVE
        tenant.save(update_fields=["status"])

        # --- a customer books, dispatch offers the new team, worker accepts ---
        customer = User.objects.create_user(phone="+998911111111")
        customer.roles.create(role=Role.CUSTOMER, tenant=None)
        customer_token = issue_token_for_role(customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {customer_token.access_token}")

        category = ServiceCategory.objects.create(name="Uy tozalash")
        tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        address = Address.objects.create(
            user=customer, raw_address="Amir Temur 1", city="Toshkent", lat="41.311", lng="69.279"
        )

        order_response = self.client.post(
            "/api/v1/orders/",
            {
                "tariff_id": tariff.id,
                "address_id": address.id,
                "scheduled_time": (timezone.now() + timezone.timedelta(days=1)).isoformat(),
            },
        )
        self.assertEqual(order_response.status_code, 201, order_response.data)
        order_id = order_response.data["id"]

        worker_token = issue_token_for_role(worker_user, "tenant_worker", tenant.id)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {worker_token.access_token}")

        accept_response = self.client.post(f"/api/v1/dispatch/orders/{order_id}/accept/")
        self.assertEqual(accept_response.status_code, 200, accept_response.data)

        order = Order.objects.get(id=order_id)
        self.assertEqual(order.status, Order.Status.ASSIGNED)
        self.assertEqual(order.tenant_id, tenant.id)
        self.assertEqual(order.team_id, team.id)
