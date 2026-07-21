from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.orders.models import Order
from apps.realtime.broadcast import broadcast_to_order, broadcast_to_team

from .models import DispatchQueue


class AcceptOfferView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, order_id):
        if getattr(request, "jwt_role", None) != "tenant_worker":
            return Response({"error": "not_a_worker"}, status=status.HTTP_403_FORBIDDEN)

        worker_profile = getattr(request.user, "worker_profile", None)
        if worker_profile is None or worker_profile.team_id is None:
            return Response({"error": "no_team_assigned"}, status=status.HTTP_403_FORBIDDEN)

        team_id = worker_profile.team_id

        with transaction.atomic():
            # skip_locked: a second team hitting accept() concurrently for
            # the same order finds no unlocked matching row and gets
            # offer=None immediately, rather than blocking on the winner's
            # transaction and then failing after the fact.
            offer = (
                DispatchQueue.objects.select_for_update(skip_locked=True)
                .filter(order_id=order_id, team_id=team_id, status=DispatchQueue.Status.PENDING)
                .first()
            )
            if offer is None:
                return Response({"error": "offer_not_available"}, status=status.HTTP_409_CONFLICT)

            order = Order.objects.select_for_update(skip_locked=True).filter(id=order_id).first()
            if order is None or order.status != Order.Status.SEARCHING:
                return Response(
                    {"error": "order_already_assigned"}, status=status.HTTP_409_CONFLICT
                )

            other_pending_team_ids = list(
                DispatchQueue.objects.filter(order=order, status=DispatchQueue.Status.PENDING)
                .exclude(id=offer.id)
                .values_list("team_id", flat=True)
            )

            offer.status = DispatchQueue.Status.ACCEPTED
            offer.is_winner = True
            offer.responded_at = timezone.now()
            offer.save(update_fields=["status", "is_winner", "responded_at"])

            order.status = Order.Status.ASSIGNED
            # worker_profile.tenant_id, not offer.team.tenant_id — the
            # latter re-fetches Team through its TenantScopedManager
            # (Team._base_manager defaults to the same scoped manager as
            # `objects`), which only happens to work here because the
            # accepting worker's own tenant context matches their team's.
            order.tenant_id = worker_profile.tenant_id
            order.save(update_fields=["status", "tenant"])

            DispatchQueue.objects.filter(order=order, status=DispatchQueue.Status.PENDING).exclude(
                id=offer.id
            ).update(status=DispatchQueue.Status.TIMEOUT)

        broadcast_to_order(order.id, "order.assigned", team_id=team_id)
        for other_team_id in other_pending_team_ids:
            broadcast_to_team(other_team_id, "order.cancelled", order_id=order.id)

        return Response({"status": "assigned"})
