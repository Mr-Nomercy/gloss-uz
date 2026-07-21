from django.utils import timezone
from rest_framework.test import APITestCase

from apps.accounts.models import User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import Addon, ServiceCategory, Tariff

from .models import Order


class BookingFlowTests(APITestCase):
    """M2 gate: a real order is created end to end through the API,
    with no mocked pricing — the server computes total_price itself.
    """

    def setUp(self):
        self.customer = User.objects.create_user(phone="+998911111111")
        token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        self.category = ServiceCategory.objects.create(name="Uy tozalash")
        self.tariff = Tariff.objects.create(
            service_category=self.category, name="Standart", base_price="50000.00", duration_min=180
        )
        self.addon = Addon.objects.create(tariff=self.tariff, name="Deraza", price="10000.00")

        self.address = Address.objects.create(
            user=self.customer,
            raw_address="Amir Temur 1",
            city="Toshkent",
            lat="41.311",
            lng="69.279",
        )

    def test_creates_real_order_with_server_computed_price(self):
        response = self.client.post(
            "/api/v1/orders/",
            {
                "tariff_id": self.tariff.id,
                "addon_ids": [self.addon.id],
                "address_id": self.address.id,
                "scheduled_time": (timezone.now() + timezone.timedelta(days=1)).isoformat(),
            },
        )

        self.assertEqual(response.status_code, 201, response.data)
        self.assertEqual(response.data["status"], Order.Status.SEARCHING)
        self.assertEqual(response.data["total_price"], "60000.00")

        order = Order.objects.get(id=response.data["id"])
        self.assertEqual(order.customer_id, self.customer.id)
        self.assertIsNone(order.tenant_id)

    def test_client_supplied_total_price_is_ignored(self):
        response = self.client.post(
            "/api/v1/orders/",
            {
                "tariff_id": self.tariff.id,
                "address_id": self.address.id,
                "scheduled_time": (timezone.now() + timezone.timedelta(days=1)).isoformat(),
                "total_price": "1.00",
            },
        )

        self.assertEqual(response.status_code, 201, response.data)
        self.assertEqual(response.data["total_price"], "50000.00")

    def test_cannot_book_someone_elses_address(self):
        other_user = User.objects.create_user(phone="+998922222222")
        other_address = Address.objects.create(
            user=other_user, raw_address="Boshqa manzil", city="Toshkent", lat="41.3", lng="69.2"
        )

        response = self.client.post(
            "/api/v1/orders/",
            {
                "tariff_id": self.tariff.id,
                "address_id": other_address.id,
                "scheduled_time": (timezone.now() + timezone.timedelta(days=1)).isoformat(),
            },
        )

        self.assertEqual(response.status_code, 400)

    def test_addon_from_a_different_tariff_is_rejected(self):
        other_tariff = Tariff.objects.create(
            service_category=self.category, name="Premium", base_price="85000.00", duration_min=240
        )
        foreign_addon = Addon.objects.create(tariff=other_tariff, name="Ekspress", price="20000.00")

        response = self.client.post(
            "/api/v1/orders/",
            {
                "tariff_id": self.tariff.id,
                "addon_ids": [foreign_addon.id],
                "address_id": self.address.id,
                "scheduled_time": (timezone.now() + timezone.timedelta(days=1)).isoformat(),
            },
        )

        self.assertEqual(response.status_code, 400)

    def test_customer_only_sees_own_orders(self):
        other_customer = User.objects.create_user(phone="+998933333333")
        other_address = Address.objects.create(
            user=other_customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        Order.objects.create(
            customer=other_customer,
            tariff=self.tariff,
            address=other_address,
            scheduled_time=timezone.now() + timezone.timedelta(days=1),
            total_price="50000.00",
        )

        response = self.client.get("/api/v1/orders/")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(len(response.data["results"]), 0)
