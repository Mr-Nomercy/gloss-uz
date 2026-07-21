from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D

from apps.realtime.broadcast import broadcast_to_order, broadcast_to_team
from apps.workforce.models import Team

from .models import DispatchQueue

DEFAULT_RADIUS_KM = 10
MAX_OFFERS = 10
OFFER_TIMEOUT_SECONDS = 15
MAX_ATTEMPTS = 3


def _order_point(order) -> Point:
    address = order.address
    return Point(float(address.lng), float(address.lat), srid=4326)


def find_eligible_teams(order, radius_km=DEFAULT_RADIUS_KM, limit=MAX_OFFERS, exclude_team_ids=()):
    """Nearest available teams across ALL active tenants — dispatch is
    deliberately cross-tenant, so this uses the unscoped manager rather
    than whatever tenant happens to be in the current request context.
    """
    point = _order_point(order)
    return (
        Team.all_tenants.filter(
            status=Team.Status.AVAILABLE, tenant__status="active", location__isnull=False
        )
        .exclude(id__in=exclude_team_ids)
        .annotate(distance=Distance("location", point))
        .filter(distance__lte=D(km=radius_km))
        .order_by("distance")[:limit]
    )


def dispatch_order(order, exclude_team_ids=(), attempt=1):
    """Create pending offers for the nearest eligible teams and schedule
    the timeout escalation. Returns the teams offered (empty if none
    found — caller decides whether that means cancelling the order).
    """
    teams = list(find_eligible_teams(order, exclude_team_ids=exclude_team_ids))
    if not teams:
        return []

    for team in teams:
        DispatchQueue.objects.get_or_create(order=order, team=team)
        broadcast_to_team(
            team.id,
            "order.new_offer",
            order_id=order.id,
            address=order.address.raw_address,
            deadline_seconds=OFFER_TIMEOUT_SECONDS,
        )

    from .tasks import expire_offer_round

    all_offered_ids = list(exclude_team_ids) + [team.id for team in teams]
    expire_offer_round.apply_async(
        args=[order.id, all_offered_ids, attempt], countdown=OFFER_TIMEOUT_SECONDS
    )
    return teams


def broadcast_order_status(order):
    broadcast_to_order(order.id, "order.status_changed", status=order.status)
