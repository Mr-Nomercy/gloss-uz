import base64
import hashlib
import json
from datetime import datetime
from datetime import timezone as dt_timezone

from django.conf import settings
from django.http import JsonResponse
from django.utils.decorators import method_decorator
from django.views import View
from django.views.decorators.csrf import csrf_exempt

from apps.market.models import MarketOrder

from . import services
from .models import Transaction

# Both gateways POST plain form/JSON bodies with their own auth scheme
# (Basic auth for Payme, an MD5 signature for Click) — not a bearer JWT,
# so these are raw Django views rather than DRF APIViews. That also
# sidesteps DEFAULT_PARSER_CLASSES only accepting camelCase JSON, which
# would reject Click's form-encoded callback.

# Payme JSON-RPC error codes — see https://developer.help.paycom.uz
_ERR_INVALID_AMOUNT = -31001
_ERR_TRANSACTION_NOT_FOUND = -31003
_ERR_UNABLE_TO_PERFORM = -31008
_ERR_ORDER_NOT_FOUND = -31050


def _ms(dt=None):
    dt = dt or datetime.now(dt_timezone.utc)
    return int(dt.timestamp() * 1000)


def _payme_state(txn):
    if txn.status == Transaction.Status.PAID:
        return 2
    if txn.status == Transaction.Status.CANCELLED:
        return -2 if txn.paid_at else -1
    return 1


@method_decorator(csrf_exempt, name="dispatch")
class PaymeWebhookView(View):
    def post(self, request):
        try:
            body = json.loads(request.body or b"{}")
        except json.JSONDecodeError:
            return self._error(None, -32700, "Parse error")

        request_id = body.get("id")
        if not self._authorized(request):
            return self._error(request_id, -32504, "Insufficient privilege")

        method = body.get("method")
        params = body.get("params") or {}
        handler = {
            "CheckPerformTransaction": self._check_perform,
            "CreateTransaction": self._create,
            "PerformTransaction": self._perform,
            "CancelTransaction": self._cancel,
            "CheckTransaction": self._check,
        }.get(method)
        if handler is None:
            return self._error(request_id, -32601, "Method not found")

        return handler(request_id, params)

    def _authorized(self, request):
        auth = request.META.get("HTTP_AUTHORIZATION", "")
        if not auth.startswith("Basic "):
            return False
        try:
            decoded = base64.b64decode(auth.removeprefix("Basic ")).decode()
            login, _, key = decoded.partition(":")
        except (ValueError, UnicodeDecodeError):
            return False
        return login == "Paycom" and key == settings.PAYME_SECRET_KEY and bool(key)

    def _order(self, params):
        order_id = (params.get("account") or {}).get("order_id")
        return MarketOrder.objects.filter(
            id=order_id, payment_method=MarketOrder.PaymentMethod.PAYME
        ).first()

    def _check_perform(self, request_id, params):
        order = self._order(params)
        if order is None:
            return self._error(request_id, _ERR_ORDER_NOT_FOUND, "Order not found")
        if int(order.total_price * 100) != params.get("amount"):
            return self._error(request_id, _ERR_INVALID_AMOUNT, "Incorrect amount")
        return self._result(request_id, {"allow": True})

    def _create(self, request_id, params):
        external_id = params.get("id")
        existing = Transaction.objects.filter(
            provider=Transaction.Provider.PAYME, external_id=external_id
        ).first()
        if existing is not None:
            if existing.status == Transaction.Status.CANCELLED:
                return self._error(request_id, _ERR_UNABLE_TO_PERFORM, "Transaction cancelled")
            return self._result(
                request_id,
                {
                    "create_time": _ms(existing.created_at),
                    "transaction": str(existing.id),
                    "state": 1,
                },
            )

        order = self._order(params)
        if order is None:
            return self._error(request_id, _ERR_ORDER_NOT_FOUND, "Order not found")
        if int(order.total_price * 100) != params.get("amount"):
            return self._error(request_id, _ERR_INVALID_AMOUNT, "Incorrect amount")

        txn = Transaction.objects.create(
            market_order=order,
            provider=Transaction.Provider.PAYME,
            external_id=external_id,
            amount=order.total_price,
            status=Transaction.Status.PENDING,
        )
        return self._result(
            request_id, {"create_time": _ms(txn.created_at), "transaction": str(txn.id), "state": 1}
        )

    def _perform(self, request_id, params):
        txn = Transaction.objects.filter(
            provider=Transaction.Provider.PAYME, external_id=params.get("id")
        ).first()
        if txn is None:
            return self._error(request_id, _ERR_TRANSACTION_NOT_FOUND, "Transaction not found")
        if txn.status == Transaction.Status.CANCELLED:
            return self._error(request_id, _ERR_UNABLE_TO_PERFORM, "Transaction cancelled")

        services.mark_paid(txn)
        return self._result(
            request_id,
            {"transaction": str(txn.id), "perform_time": _ms(txn.paid_at), "state": 2},
        )

    def _cancel(self, request_id, params):
        txn = Transaction.objects.filter(
            provider=Transaction.Provider.PAYME, external_id=params.get("id")
        ).first()
        if txn is None:
            return self._error(request_id, _ERR_TRANSACTION_NOT_FOUND, "Transaction not found")

        services.mark_cancelled(txn)
        return self._result(
            request_id,
            {
                "transaction": str(txn.id),
                "cancel_time": _ms(txn.cancelled_at),
                "state": _payme_state(txn),
            },
        )

    def _check(self, request_id, params):
        txn = Transaction.objects.filter(
            provider=Transaction.Provider.PAYME, external_id=params.get("id")
        ).first()
        if txn is None:
            return self._error(request_id, _ERR_TRANSACTION_NOT_FOUND, "Transaction not found")

        return self._result(
            request_id,
            {
                "create_time": _ms(txn.created_at),
                "perform_time": _ms(txn.paid_at) if txn.paid_at else 0,
                "cancel_time": _ms(txn.cancelled_at) if txn.cancelled_at else 0,
                "transaction": str(txn.id),
                "state": _payme_state(txn),
                "reason": None,
            },
        )

    def _result(self, request_id, result):
        return JsonResponse({"result": result, "id": request_id})

    def _error(self, request_id, code, message):
        return JsonResponse({"error": {"code": code, "message": message}, "id": request_id})


@method_decorator(csrf_exempt, name="dispatch")
class ClickWebhookView(View):
    """https://docs.click.uz/en/click-api-request/ — a single endpoint
    handling both the Prepare (action=0) and Complete (action=1) steps."""

    def post(self, request):
        data = request.POST or json.loads(request.body or b"{}")
        action = str(data.get("action"))

        if not self._signature_valid(data, action):
            return self._response(data, error=-1, error_note="SIGN CHECK FAILED")

        order = MarketOrder.objects.filter(
            id=data.get("merchant_trans_id"), payment_method=MarketOrder.PaymentMethod.CLICK
        ).first()
        if order is None:
            return self._response(data, error=-5, error_note="Order not found")

        if action == "0":
            return self._prepare(data, order)
        if action == "1":
            return self._complete(data, order)
        return self._response(data, error=-3, error_note="Action not found")

    def _signature_valid(self, data, action):
        key = settings.CLICK_SECRET_KEY
        if not key:
            return False
        parts = [
            data.get("click_trans_id"),
            data.get("service_id"),
            key,
            data.get("merchant_trans_id"),
        ]
        if action == "1":
            parts.append(data.get("merchant_prepare_id"))
        parts += [data.get("amount"), data.get("action"), data.get("sign_time")]
        expected = hashlib.md5("".join(str(p) for p in parts).encode()).hexdigest()
        return expected == data.get("sign_string")

    def _prepare(self, data, order):
        if float(data.get("amount", 0)) != float(order.total_price):
            return self._response(data, error=-2, error_note="Incorrect amount")

        txn, _ = Transaction.objects.get_or_create(
            provider=Transaction.Provider.CLICK,
            external_id=data.get("click_trans_id"),
            defaults={
                "market_order": order,
                "amount": order.total_price,
                "status": Transaction.Status.PENDING,
            },
        )
        return self._response(data, merchant_prepare_id=txn.id)

    def _complete(self, data, order):
        txn = Transaction.objects.filter(
            provider=Transaction.Provider.CLICK, external_id=data.get("click_trans_id")
        ).first()
        if txn is None:
            return self._response(data, error=-6, error_note="Transaction not found")

        if str(data.get("error", "0")).startswith("-"):
            services.mark_cancelled(txn)
        else:
            services.mark_paid(txn)

        return self._response(data, merchant_confirm_id=txn.id)

    def _response(self, data, error=0, error_note="Success", **extra):
        payload = {
            "click_trans_id": data.get("click_trans_id"),
            "merchant_trans_id": data.get("merchant_trans_id"),
            "error": error,
            "error_note": error_note,
        }
        payload.update(extra)
        return JsonResponse(payload)
