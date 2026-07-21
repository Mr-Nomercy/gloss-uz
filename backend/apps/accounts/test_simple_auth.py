from unittest.mock import patch

from rest_framework.test import APITestCase

from .models import Role, User


class SimpleLoginRegisterTests(APITestCase):
    """gloss_user/gloss_worker/gloss_delivery's combined /auth/login and
    /auth/register contract (phone+otp in one endpoint, role passed
    directly at register) — a deliberately different shape from
    apps.accounts' own two-step otp/send+otp/verify+register flow.
    """

    def _sent_code(self, mock_send):
        return mock_send.call_args.args[1]

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_login_sends_then_verifies_and_returns_tokens_for_existing_user(self, mock_send):
        phone = "+998911111111"
        user = User.objects.create_user(phone=phone, full_name="Mijoz")
        user.roles.create(role=Role.CUSTOMER, tenant=None)

        send_response = self.client.post("/api/v1/auth/login", {"phone": phone})
        self.assertEqual(send_response.status_code, 200)
        code = self._sent_code(mock_send)

        verify_response = self.client.post("/api/v1/auth/login", {"phone": phone, "otp": code})
        self.assertEqual(verify_response.status_code, 200, verify_response.data)
        body = verify_response.json()
        self.assertIn("accessToken", body)
        self.assertEqual(body["user"]["phone"], phone)

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_login_verify_for_unregistered_phone_returns_404(self, mock_send):
        phone = "+998922222222"
        self.client.post("/api/v1/auth/login", {"phone": phone})
        code = self._sent_code(mock_send)

        response = self.client.post("/api/v1/auth/login", {"phone": phone, "otp": code})

        self.assertEqual(response.status_code, 404)

    def test_register_client_role_succeeds(self):
        response = self.client.post(
            "/api/v1/auth/register",
            {"phone": "+998933333333", "full_name": "Yangi Mijoz", "role": "client"},
        )

        self.assertEqual(response.status_code, 201, response.data)
        user = User.objects.get(phone="+998933333333")
        self.assertEqual(user.roles.get().role, Role.CUSTOMER)

    def test_register_courier_role_succeeds(self):
        response = self.client.post(
            "/api/v1/auth/register",
            {"phone": "+998944444444", "full_name": "Kuryer", "role": "courier"},
        )

        self.assertEqual(response.status_code, 201, response.data)
        user = User.objects.get(phone="+998944444444")
        self.assertEqual(user.roles.get().role, Role.COURIER)

    def test_register_worker_role_rejected_with_clear_error_not_silently_granted(self):
        response = self.client.post(
            "/api/v1/auth/register",
            {"phone": "+998955555555", "full_name": "Ishchi", "role": "worker"},
        )

        self.assertEqual(response.status_code, 400)
        self.assertFalse(User.objects.filter(phone="+998955555555").exists())

    @patch("apps.otp.providers.ConsoleOtpProvider.send")
    def test_blocked_user_cannot_log_in_via_otp_even_with_correct_code(self, mock_send):
        phone = "+998966666666"
        user = User.objects.create_user(phone=phone, full_name="Bloklangan", is_blocked=True)
        user.roles.create(role=Role.CUSTOMER, tenant=None)

        self.client.post("/api/v1/auth/login", {"phone": phone})
        code = self._sent_code(mock_send)

        response = self.client.post("/api/v1/auth/login", {"phone": phone, "otp": code})

        self.assertEqual(response.status_code, 403)
