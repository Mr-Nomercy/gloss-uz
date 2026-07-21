import base64
import hashlib
import json

from django.test import TestCase, override_settings

from apps.accounts.models import User
from apps.addresses.models import Address
from apps.delivery.models import DeliveryAssignment
from apps.market.models import MarketOrder

from .models import Transaction


def _payme_auth_header(secret_key):
    token = base64.b64encode(f"Paycom:{secret_key}".encode()).decode()
    return f"Basic {token}"


@override_settings(PAYME_MERCHANT_ID="test-merchant", PAYME_SECRET_KEY="test-secret")
class PaymeWebhookTests(TestCase):
    def setUp(self):
        customer = User.objects.create_user(phone="+998911111111")
        address = Address.objects.create(
            user=customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = MarketOrder.objects.create(
            customer=customer,
            address=address,
            payment_method=MarketOrder.PaymentMethod.PAYME,
            total_price="25000.00",
        )
        self.auth = {"HTTP_AUTHORIZATION": _payme_auth_header("test-secret")}

    def _call(self, method, params, request_id=1):
        body = json.dumps({"method": method, "params": params, "id": request_id})
        response = self.client.post(
            "/api/v1/payments/payme/webhook/",
            data=body,
            content_type="application/json",
            **self.auth,
        )
        return response.json()

    def test_rejects_wrong_auth(self):
        body = json.dumps(
            {
                "method": "CheckPerformTransaction",
                "params": {"amount": 2500000, "account": {"order_id": str(self.order.id)}},
                "id": 1,
            }
        )
        response = self.client.post(
            "/api/v1/payments/payme/webhook/",
            data=body,
            content_type="application/json",
            HTTP_AUTHORIZATION=_payme_auth_header("wrong-secret"),
        )
        self.assertEqual(response.json()["error"]["code"], -32504)

    def test_check_perform_transaction(self):
        result = self._call(
            "CheckPerformTransaction",
            {"amount": 2500000, "account": {"order_id": str(self.order.id)}},
        )
        self.assertEqual(result["result"], {"allow": True})

    def test_check_perform_transaction_rejects_wrong_amount(self):
        result = self._call(
            "CheckPerformTransaction", {"amount": 1, "account": {"order_id": str(self.order.id)}}
        )
        self.assertEqual(result["error"]["code"], -31001)

    def test_full_create_perform_flow_confirms_order_and_dispatches_delivery(self):
        create_result = self._call(
            "CreateTransaction",
            {
                "id": "payme-txn-1",
                "time": 1,
                "amount": 2500000,
                "account": {"order_id": str(self.order.id)},
            },
        )
        self.assertEqual(create_result["result"]["state"], 1)

        txn = Transaction.objects.get(external_id="payme-txn-1")
        self.assertEqual(txn.status, Transaction.Status.PENDING)

        perform_result = self._call("PerformTransaction", {"id": "payme-txn-1"})
        self.assertEqual(perform_result["result"]["state"], 2)

        txn.refresh_from_db()
        self.assertEqual(txn.status, Transaction.Status.PAID)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.CONFIRMED)
        self.assertTrue(DeliveryAssignment.objects.filter(market_order=self.order).exists())

    def test_cancel_transaction(self):
        self._call(
            "CreateTransaction",
            {
                "id": "payme-txn-2",
                "time": 1,
                "amount": 2500000,
                "account": {"order_id": str(self.order.id)},
            },
        )
        result = self._call("CancelTransaction", {"id": "payme-txn-2", "reason": 3})
        self.assertEqual(result["result"]["state"], -1)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.CANCELLED)

    def test_cancel_transaction_restores_stock_reserved_at_checkout(self):
        from apps.market.models import MarketOrderItem, Product

        product = Product.objects.create(name="Changyutgich", price="25000.00", stock_qty=7)
        MarketOrderItem.objects.create(
            market_order=self.order, product=product, qty=3, unit_price="25000.00"
        )

        self._call(
            "CreateTransaction",
            {
                "id": "payme-txn-3",
                "time": 1,
                "amount": 2500000,
                "account": {"order_id": str(self.order.id)},
            },
        )
        self._call("CancelTransaction", {"id": "payme-txn-3", "reason": 3})

        product.refresh_from_db()
        self.assertEqual(product.stock_qty, 10)


@override_settings(
    CLICK_SERVICE_ID="svc-1", CLICK_MERCHANT_ID="merchant-1", CLICK_SECRET_KEY="click-secret"
)
class ClickWebhookTests(TestCase):
    def setUp(self):
        customer = User.objects.create_user(phone="+998911111111")
        address = Address.objects.create(
            user=customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = MarketOrder.objects.create(
            customer=customer,
            address=address,
            payment_method=MarketOrder.PaymentMethod.CLICK,
            total_price="25000.00",
        )

    def _sign(
        self, click_trans_id, merchant_trans_id, amount, action, sign_time, merchant_prepare_id=None
    ):
        parts = [click_trans_id, "svc-1", "click-secret", merchant_trans_id]
        if action == 1:
            parts.append(merchant_prepare_id)
        parts += [amount, action, sign_time]
        return hashlib.md5("".join(str(p) for p in parts).encode()).hexdigest()

    def test_prepare_then_complete_confirms_order(self):
        prepare_sign = self._sign("click-1", str(self.order.id), "25000.00", 0, "111")
        prepare_response = self.client.post(
            "/api/v1/payments/click/webhook/",
            {
                "click_trans_id": "click-1",
                "service_id": "svc-1",
                "merchant_trans_id": str(self.order.id),
                "amount": "25000.00",
                "action": 0,
                "sign_time": "111",
                "sign_string": prepare_sign,
            },
        )
        prepare_body = prepare_response.json()
        self.assertEqual(prepare_body["error"], 0)
        merchant_prepare_id = prepare_body["merchant_prepare_id"]

        txn = Transaction.objects.get(external_id="click-1")
        self.assertEqual(txn.status, Transaction.Status.PENDING)

        complete_sign = self._sign(
            "click-1",
            str(self.order.id),
            "25000.00",
            1,
            "112",
            merchant_prepare_id=merchant_prepare_id,
        )
        complete_response = self.client.post(
            "/api/v1/payments/click/webhook/",
            {
                "click_trans_id": "click-1",
                "service_id": "svc-1",
                "merchant_trans_id": str(self.order.id),
                "merchant_prepare_id": merchant_prepare_id,
                "amount": "25000.00",
                "action": 1,
                "sign_time": "112",
                "error": 0,
                "sign_string": complete_sign,
            },
        )
        complete_body = complete_response.json()
        self.assertEqual(complete_body["error"], 0)

        txn.refresh_from_db()
        self.assertEqual(txn.status, Transaction.Status.PAID)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.CONFIRMED)

    def test_prepare_rejects_bad_signature(self):
        response = self.client.post(
            "/api/v1/payments/click/webhook/",
            {
                "click_trans_id": "click-2",
                "service_id": "svc-1",
                "merchant_trans_id": str(self.order.id),
                "amount": "25000.00",
                "action": 0,
                "sign_time": "111",
                "sign_string": "not-the-real-signature",
            },
        )
        self.assertEqual(response.json()["error"], -1)
