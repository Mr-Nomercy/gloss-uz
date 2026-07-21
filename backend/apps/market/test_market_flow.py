from rest_framework.test import APITestCase

from apps.accounts.models import User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.delivery.models import DeliveryAssignment

from .models import Category, MarketOrder, Product


class MarketCartCheckoutTests(APITestCase):
    """M6 gate: cart -> checkout -> a real MarketOrder + delivery
    assignment, no mocks beyond the payment gateway (out of scope for
    the cash path tested here — see apps.payments' own tests)."""

    def setUp(self):
        self.customer = User.objects.create_user(phone="+998911111111")
        token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        category = Category.objects.create(name="Kimyoviy vositalar")
        self.product = Product.objects.create(
            name="Idish yuvish vositasi", price="25000.00", stock_qty=10, category=category
        )
        self.address = Address.objects.create(
            user=self.customer, raw_address="Amir Temur 1", city="Toshkent", lat="41.3", lng="69.2"
        )

    def test_add_to_cart_and_checkout_with_cash(self):
        response = self.client.get("/api/v1/market/products/")
        self.assertEqual(response.status_code, 200, response.data)
        self.assertEqual(len(response.data), 1)

        add_response = self.client.post(
            "/api/v1/market/cart/items/", {"product_id": self.product.id, "qty": 2}
        )
        self.assertEqual(add_response.status_code, 200, add_response.data)
        self.assertEqual(add_response.json()["totalPrice"], "50000.00")

        checkout_response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": self.address.id, "payment_method": "cash"},
        )
        self.assertEqual(checkout_response.status_code, 201, checkout_response.data)
        self.assertEqual(checkout_response.data["status"], MarketOrder.Status.CONFIRMED)
        self.assertEqual(checkout_response.json()["totalPrice"], "50000.00")

        order = MarketOrder.objects.get(id=checkout_response.data["id"])
        self.assertEqual(order.items.count(), 1)

        self.product.refresh_from_db()
        self.assertEqual(self.product.stock_qty, 8)

        self.assertTrue(DeliveryAssignment.objects.filter(market_order=order).exists())

        cart_response = self.client.get("/api/v1/market/cart/")
        self.assertEqual(cart_response.data["items"], [])

    def test_checkout_rejects_someone_elses_address(self):
        other_user = User.objects.create_user(phone="+998922222222")
        other_address = Address.objects.create(
            user=other_user, raw_address="Boshqa", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.client.post("/api/v1/market/cart/items/", {"product_id": self.product.id, "qty": 1})

        response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": other_address.id, "payment_method": "cash"},
        )
        self.assertEqual(response.status_code, 400)

    def test_checkout_rejects_insufficient_stock(self):
        self.client.post("/api/v1/market/cart/items/", {"product_id": self.product.id, "qty": 3})
        self.product.stock_qty = 1
        self.product.save(update_fields=["stock_qty"])

        response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": self.address.id, "payment_method": "cash"},
        )
        self.assertEqual(response.status_code, 400)

    def test_checkout_with_empty_cart_is_rejected(self):
        response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": self.address.id, "payment_method": "cash"},
        )
        self.assertEqual(response.status_code, 400)

    def test_checkout_with_payme_returns_pay_url_and_stays_pending(self):
        self.client.post("/api/v1/market/cart/items/", {"product_id": self.product.id, "qty": 1})

        response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": self.address.id, "payment_method": "payme"},
        )
        self.assertEqual(response.status_code, 201, response.data)
        self.assertEqual(response.data["status"], MarketOrder.Status.PENDING)
        body = response.json()
        self.assertIn("payUrl", body)
        self.assertTrue(body["payUrl"].startswith("https://checkout.paycom.uz/"))

        order = MarketOrder.objects.get(id=response.data["id"])
        self.assertFalse(DeliveryAssignment.objects.filter(market_order=order).exists())

    def test_cancelling_a_pending_order_restores_stock(self):
        self.client.post("/api/v1/market/cart/items/", {"product_id": self.product.id, "qty": 3})
        checkout_response = self.client.post(
            "/api/v1/market/cart/checkout/",
            {"address_id": self.address.id, "payment_method": "payme"},
        )
        order_id = checkout_response.data["id"]
        self.product.refresh_from_db()
        self.assertEqual(self.product.stock_qty, 7)

        cancel_response = self.client.post(f"/api/v1/market/market-orders/{order_id}/cancel/")
        self.assertEqual(cancel_response.status_code, 200, cancel_response.data)

        self.product.refresh_from_db()
        self.assertEqual(self.product.stock_qty, 10)
