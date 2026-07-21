from rest_framework.test import APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role

from .models import DeviceToken, Notification
from .services import notify


class NotificationApiTests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(phone="+998911111111", full_name="Test")
        self.user.roles.create(role=Role.CUSTOMER, tenant=None)
        token = issue_token_for_role(self.user, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

    def test_list_only_returns_own_notifications(self):
        other = User.objects.create_user(phone="+998922222222")
        notify(self.user, "Mine", "body")
        notify(other, "Not mine", "body")

        response = self.client.get("/api/v1/notifications/")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]["title"], "Mine")

    def test_mark_read(self):
        notification = notify(self.user, "Hello", "body")
        self.assertIsNone(notification.read_at)

        response = self.client.post(f"/api/v1/notifications/{notification.id}/read/")

        self.assertEqual(response.status_code, 200)
        notification.refresh_from_db()
        self.assertIsNotNone(notification.read_at)

    def test_cannot_mark_someone_elses_notification_read(self):
        other = User.objects.create_user(phone="+998922222222")
        notification = notify(other, "Not mine", "body")

        response = self.client.post(f"/api/v1/notifications/{notification.id}/read/")

        self.assertEqual(response.status_code, 404)

    def test_register_device_token(self):
        response = self.client.post(
            "/api/v1/device-token/", {"token": "abc123", "platform": "android"}
        )

        self.assertEqual(response.status_code, 201)
        self.assertTrue(DeviceToken.objects.filter(user=self.user, token="abc123").exists())

    def test_notify_creates_row_even_with_no_device_token(self):
        notification = notify(self.user, "Title", "Body", Notification.Type.ORDER)

        self.assertEqual(notification.user, self.user)
        self.assertEqual(notification.type, Notification.Type.ORDER)
