from unittest.mock import patch

from rest_framework.test import APITestCase

from apps.tenants.models import Tenant
from apps.workforce.models import WorkerInviteCode, WorkerProfile

from .models import Role, User


class OtpAndRegistrationFlowTests(APITestCase):
    """M2 gate: OTP -> register (new customer) and OTP -> worker/register
    (invite-code) both work end to end through the real API, no mocks
    beyond the OTP provider (no real SMS/Telegram credentials exist).
    """

    def _sent_code(self, mock_provider):
        # ConsoleOtpProvider logs the code rather than returning it, so
        # capture it directly off the provider's send() call in tests.
        return mock_provider.call_args.args[1]

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_new_customer_registers_via_otp(self, mock_send):
        phone = "+998911111111"

        send_response = self.client.post(
            "/api/v1/auth/otp/send/", {"phone": phone, "channel": "sms"}
        )
        self.assertEqual(send_response.status_code, 200)
        code = self._sent_code(mock_send)

        verify_response = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": phone, "code": code}
        )
        self.assertEqual(verify_response.status_code, 200)
        self.assertEqual(verify_response.data["status"], "new_user")
        verified_token = verify_response.data["verified_token"]

        register_response = self.client.post(
            "/api/v1/auth/register/",
            {
                "verified_token": verified_token,
                "full_name": "Test Customer",
                "marketing_consent": True,
            },
        )

        self.assertEqual(register_response.status_code, 201, register_response.data)
        self.assertIn("access", register_response.data)

        user = User.objects.get(phone=phone)
        self.assertTrue(user.marketing_consent)
        self.assertEqual(user.roles.get().role, Role.CUSTOMER)

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_returning_user_logs_in_directly_without_register_step(self, mock_send):
        phone = "+998922222222"
        user = User.objects.create_user(phone=phone, full_name="Existing")
        user.roles.create(role=Role.CUSTOMER, tenant=None)

        self.client.post("/api/v1/auth/otp/send/", {"phone": phone, "channel": "sms"})
        code = self._sent_code(mock_send)

        verify_response = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": phone, "code": code}
        )

        self.assertEqual(verify_response.status_code, 200)
        self.assertEqual(verify_response.data["status"], "login")
        self.assertIn("access", verify_response.data)

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_worker_registers_via_tenant_invite_code(self, mock_send):
        phone = "+998933333333"
        tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")
        invite = WorkerInviteCode.generate(tenant)

        self.client.post("/api/v1/auth/otp/send/", {"phone": phone, "channel": "telegram"})
        code = self._sent_code(mock_send)
        verify_response = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": phone, "code": code}
        )
        verified_token = verify_response.data["verified_token"]

        response = self.client.post(
            "/api/v1/auth/worker/register/",
            {
                "verified_token": verified_token,
                "invite_code": invite.code,
                "full_name": "Worker One",
            },
        )

        self.assertEqual(response.status_code, 201, response.data)

        user = User.objects.get(phone=phone)
        role = user.roles.get()
        self.assertEqual(role.role, Role.TENANT_WORKER)
        self.assertEqual(role.tenant_id, tenant.id)
        self.assertTrue(WorkerProfile.all_tenants.filter(user=user, tenant=tenant).exists())

        invite.refresh_from_db()
        self.assertTrue(invite.is_used)
        self.assertEqual(invite.used_by_id, user.id)

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_worker_registration_rejects_used_invite_code(self, mock_send):
        tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")
        invite = WorkerInviteCode.generate(tenant)
        invite.is_used = True
        invite.save(update_fields=["is_used"])

        phone = "+998944444444"
        self.client.post("/api/v1/auth/otp/send/", {"phone": phone, "channel": "sms"})
        code = self._sent_code(mock_send)
        verify_response = self.client.post(
            "/api/v1/auth/otp/verify/", {"phone": phone, "code": code}
        )
        verified_token = verify_response.data["verified_token"]

        response = self.client.post(
            "/api/v1/auth/worker/register/",
            {"verified_token": verified_token, "invite_code": invite.code, "full_name": "Someone"},
        )

        self.assertEqual(response.status_code, 400)
        self.assertFalse(User.objects.filter(phone=phone).exists())

    def test_wrong_otp_code_is_rejected(self):
        phone = "+998955555555"
        with patch("apps.otp.providers.ConsoleOtpProvider.send"):
            self.client.post("/api/v1/auth/otp/send/", {"phone": phone, "channel": "sms"})

        response = self.client.post("/api/v1/auth/otp/verify/", {"phone": phone, "code": "0000"})

        self.assertEqual(response.status_code, 400)
