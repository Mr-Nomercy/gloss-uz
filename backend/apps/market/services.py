from django.db import transaction
from django.db.models import F

from .models import Product


def restore_stock(order):
    """Gives back the stock reserved at checkout — call exactly once,
    at the point an order actually transitions to CANCELLED. Needed
    because checkout decrements stock immediately for every payment
    method (including payme/click, which stay PENDING until the gateway
    webhook confirms) — without this, an abandoned or declined payment
    would permanently leak that inventory.
    """
    with transaction.atomic():
        for item in order.items.all():
            Product.objects.filter(id=item.product_id).update(stock_qty=F("stock_qty") + item.qty)
