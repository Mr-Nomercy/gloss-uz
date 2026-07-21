from django.db import transaction as db_transaction
from django.utils import timezone

from apps.delivery.services import dispatch_market_order
from apps.market.models import MarketOrder
from apps.market.services import restore_stock

from .models import Transaction


def mark_paid(txn: Transaction):
    """Idempotent: a gateway may retry its confirm callback, so a
    transaction already PAID is a no-op rather than double-dispatching
    delivery or re-notifying."""
    if txn.status == Transaction.Status.PAID:
        return txn

    with db_transaction.atomic():
        txn.status = Transaction.Status.PAID
        txn.paid_at = timezone.now()
        txn.save(update_fields=["status", "paid_at"])

        order = txn.market_order
        order.status = MarketOrder.Status.CONFIRMED
        order.save(update_fields=["status"])
        dispatch_market_order(order)

    return txn


def mark_cancelled(txn: Transaction):
    if txn.status == Transaction.Status.CANCELLED:
        return txn

    with db_transaction.atomic():
        txn.status = Transaction.Status.CANCELLED
        txn.cancelled_at = timezone.now()
        txn.save(update_fields=["status", "cancelled_at"])

        order = txn.market_order
        if order.status == MarketOrder.Status.PENDING:
            order.status = MarketOrder.Status.CANCELLED
            order.save(update_fields=["status"])
            restore_stock(order)

    return txn
