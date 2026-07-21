from .models import DeliveryAssignment


def dispatch_market_order(market_order):
    """Opens the order up for eligible couriers to browse and claim.

    Unlike apps.dispatch's cleaning-order flow, there's no escalation
    queue or offer timeout here — Gloss's own courier fleet is small
    enough that "first courier to accept wins" (DeliveryAssignmentAcceptView's
    select_for_update(skip_locked=True)) is sufficient, no Celery task
    needed.
    """
    return DeliveryAssignment.objects.create(market_order=market_order)
