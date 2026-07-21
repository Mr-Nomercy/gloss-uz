from celery import shared_task
from django.utils import timezone

from apps.orders.models import Order

from . import services
from .models import DispatchQueue


@shared_task
def expire_offer_round(order_id, offered_team_ids, attempt=1):
    try:
        order = Order.objects.get(id=order_id)
    except Order.DoesNotExist:
        return

    if order.status != Order.Status.SEARCHING:
        return  # already accepted or cancelled by the time this fired

    DispatchQueue.objects.filter(order=order, status=DispatchQueue.Status.PENDING).update(
        status=DispatchQueue.Status.TIMEOUT, responded_at=timezone.now()
    )

    if attempt >= services.MAX_ATTEMPTS:
        order.status = Order.Status.CANCELLED
        order.save(update_fields=["status"])
        services.broadcast_order_status(order)
        return

    new_offers = services.dispatch_order(
        order, exclude_team_ids=offered_team_ids, attempt=attempt + 1
    )
    if not new_offers:
        order.status = Order.Status.CANCELLED
        order.save(update_fields=["status"])
        services.broadcast_order_status(order)
