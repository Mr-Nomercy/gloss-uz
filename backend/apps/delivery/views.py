from django.db import models as db_models
from django.db import transaction
from django.utils import timezone
from rest_framework import mixins, status, viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.market.models import MarketOrder
from apps.notifications.services import notify

from .models import Courier, DeliveryAssignment
from .serializers import DeliveryAssignmentSerializer

# Worker-driven progression only — claiming a PENDING assignment is
# handled separately by DeliveryAssignmentAcceptView.
_NEXT_STATUS = {
    DeliveryAssignment.Status.ACCEPTED: DeliveryAssignment.Status.PICKED_UP,
    DeliveryAssignment.Status.PICKED_UP: DeliveryAssignment.Status.DELIVERED,
}
_MARKET_ORDER_STATUS = {
    DeliveryAssignment.Status.PICKED_UP: MarketOrder.Status.PICKED_UP,
    DeliveryAssignment.Status.DELIVERED: MarketOrder.Status.DELIVERED,
}


class DeliveryAssignmentViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    """Courier app: browse unclaimed assignments plus whichever one this
    courier is currently working — not their full delivery history,
    which would otherwise grow unbounded in this same list forever."""

    serializer_class = DeliveryAssignmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        courier_profile = getattr(self.request.user, "courier_profile", None)
        if courier_profile is None:
            return DeliveryAssignment.objects.none()
        active_statuses = (
            DeliveryAssignment.Status.ACCEPTED,
            DeliveryAssignment.Status.PICKED_UP,
        )
        return DeliveryAssignment.objects.filter(
            db_models.Q(status=DeliveryAssignment.Status.PENDING)
            | db_models.Q(courier=courier_profile, status__in=active_statuses)
        )


class DeliveryAssignmentAcceptView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        courier_profile = getattr(request.user, "courier_profile", None)
        if courier_profile is None:
            return Response({"error": "not_a_courier"}, status=status.HTTP_403_FORBIDDEN)

        with transaction.atomic():
            # skip_locked: a second courier hitting accept() for the same
            # assignment finds no unlocked matching row and gets None
            # immediately, rather than blocking on the winner's transaction.
            assignment = (
                DeliveryAssignment.objects.select_for_update(skip_locked=True)
                .filter(id=pk, status=DeliveryAssignment.Status.PENDING)
                .first()
            )
            if assignment is None:
                return Response(
                    {"error": "assignment_not_available"}, status=status.HTTP_409_CONFLICT
                )

            assignment.courier = courier_profile
            assignment.status = DeliveryAssignment.Status.ACCEPTED
            assignment.assigned_at = timezone.now()
            assignment.save(update_fields=["courier", "status", "assigned_at"])

            market_order = assignment.market_order
            market_order.status = MarketOrder.Status.ASSIGNED_COURIER
            market_order.save(update_fields=["status"])

            courier_profile.status = Courier.Status.BUSY
            courier_profile.save(update_fields=["status"])

        notify(
            market_order.customer,
            "Kuryer tayinlandi",
            f"Buyurtma #{market_order.id} uchun kuryer topildi.",
        )
        return Response(DeliveryAssignmentSerializer(assignment).data)


class DeliveryAssignmentStatusView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        courier_profile = getattr(request.user, "courier_profile", None)
        if courier_profile is None:
            return Response({"error": "not_a_courier"}, status=status.HTTP_403_FORBIDDEN)

        assignment = DeliveryAssignment.objects.filter(id=pk, courier=courier_profile).first()
        if assignment is None:
            return Response(status=status.HTTP_404_NOT_FOUND)

        expected_next = _NEXT_STATUS.get(assignment.status)
        requested = request.data.get("status")
        if expected_next is None or requested != expected_next:
            return Response(
                {"error": "invalid_transition", "expected": expected_next},
                status=status.HTTP_400_BAD_REQUEST,
            )

        assignment.status = expected_next
        update_fields = ["status"]
        if expected_next == DeliveryAssignment.Status.PICKED_UP:
            assignment.picked_up_at = timezone.now()
            update_fields.append("picked_up_at")
        elif expected_next == DeliveryAssignment.Status.DELIVERED:
            assignment.delivered_at = timezone.now()
            update_fields.append("delivered_at")

        with transaction.atomic():
            assignment.save(update_fields=update_fields)
            market_order = assignment.market_order
            market_order.status = _MARKET_ORDER_STATUS[expected_next]
            market_order.save(update_fields=["status"])
            if expected_next == DeliveryAssignment.Status.DELIVERED:
                courier_profile.status = Courier.Status.AVAILABLE
                courier_profile.save(update_fields=["status"])

        if expected_next == DeliveryAssignment.Status.DELIVERED:
            notify(
                market_order.customer,
                "Buyurtma yetkazildi",
                f"Buyurtma #{market_order.id} yetkazib berildi.",
            )

        return Response(DeliveryAssignmentSerializer(assignment).data)
