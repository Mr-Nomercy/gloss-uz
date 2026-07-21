from django.db import transaction
from django.utils import timezone
from rest_framework import mixins, status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.dispatch.models import DispatchQueue
from apps.notifications.services import notify
from apps.realtime.broadcast import broadcast_to_order
from apps.tenants.billing import bill_completed_order

from .models import Order, Review
from .serializers import OrderCreateSerializer, OrderSerializer, RateSerializer, ReviewSerializer

REASON_REQUIRED_STATUSES = {Order.Status.ASSIGNED, Order.Status.EN_ROUTE, Order.Status.ARRIVED}
NOT_CANCELLABLE_STATUSES = {Order.Status.COMPLETED, Order.Status.RATED, Order.Status.CANCELLED}

# Worker-driven progression only — dispatch (SEARCHING -> ASSIGNED) and
# cancel are handled elsewhere (AcceptOfferView, OrderViewSet.cancel).
_NEXT_WORKER_STATUS = {
    Order.Status.ASSIGNED: Order.Status.EN_ROUTE,
    Order.Status.EN_ROUTE: Order.Status.ARRIVED,
    Order.Status.ARRIVED: Order.Status.IN_PROGRESS,
    Order.Status.IN_PROGRESS: Order.Status.COMPLETED,
}


class OrderViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    viewsets.GenericViewSet,
):
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # platform_admin needs to reach any order — most importantly to
        # cancel one stuck `in_progress` (see cancel() below); without
        # this, get_object() 404s before that permission check is ever
        # reached, making the admin-only-in-progress-cancel rule dead code.
        if getattr(self.request, "jwt_role", None) == "platform_admin":
            return Order.objects.all().order_by("-created_at")
        return Order.objects.filter(customer=self.request.user).order_by("-created_at")

    def get_serializer_class(self):
        if self.action == "create":
            return OrderCreateSerializer
        return OrderSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        order = serializer.save()
        return Response(OrderSerializer(order).data, status=status.HTTP_201_CREATED)

    @action(detail=True, methods=["post"])
    def cancel(self, request, pk=None):
        order = self.get_object()

        if order.status in NOT_CANCELLABLE_STATUSES:
            return Response(
                {"error": "cannot_cancel_in_current_status"}, status=status.HTTP_400_BAD_REQUEST
            )

        if order.status == Order.Status.IN_PROGRESS:
            if getattr(request, "jwt_role", None) != "platform_admin":
                return Response(
                    {"error": "only_platform_admin_can_cancel_in_progress"},
                    status=status.HTTP_403_FORBIDDEN,
                )
        elif order.status in REASON_REQUIRED_STATUSES and not request.data.get("reason"):
            return Response({"error": "reason_required"}, status=status.HTTP_400_BAD_REQUEST)

        order.status = Order.Status.CANCELLED
        order.save(update_fields=["status"])
        DispatchQueue.objects.filter(order=order, status=DispatchQueue.Status.PENDING).update(
            status=DispatchQueue.Status.TIMEOUT
        )
        broadcast_to_order(order.id, "order.status_changed", status=order.status)
        notify(order.customer, "Buyurtma bekor qilindi", f"Buyurtma #{order.id} bekor qilindi.")

        return Response(OrderSerializer(order).data)

    @action(detail=True, methods=["post"])
    def rate(self, request, pk=None):
        order = self.get_object()

        if order.status != Order.Status.COMPLETED:
            return Response({"error": "order_not_completed"}, status=status.HTTP_400_BAD_REQUEST)
        if Review.objects.filter(order=order).exists():
            return Response({"error": "already_rated"}, status=status.HTTP_400_BAD_REQUEST)

        serializer = RateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        with transaction.atomic():
            review = Review.objects.create(
                order=order, customer=request.user, team=order.team, **serializer.validated_data
            )
            order.status = Order.Status.RATED
            order.save(update_fields=["status"])
            if order.team_id is not None:
                order.team.recalculate_rating()

        broadcast_to_order(order.id, "order.status_changed", status=order.status)
        return Response(ReviewSerializer(review).data, status=status.HTTP_201_CREATED)


class WorkerOrderStatusView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request, pk):
        if getattr(request, "jwt_role", None) != "tenant_worker":
            return Response({"error": "not_a_worker"}, status=status.HTTP_403_FORBIDDEN)

        worker_profile = getattr(request.user, "worker_profile", None)
        if worker_profile is None or worker_profile.team_id is None:
            return Response({"error": "no_team_assigned"}, status=status.HTTP_403_FORBIDDEN)

        with transaction.atomic():
            order = Order.objects.select_for_update().filter(id=pk).first()
            if order is None:
                return Response(status=status.HTTP_404_NOT_FOUND)
            if order.team_id != worker_profile.team_id:
                return Response({"error": "not_your_order"}, status=status.HTTP_403_FORBIDDEN)

            expected_next = _NEXT_WORKER_STATUS.get(order.status)
            requested = request.data.get("status")
            if expected_next is None or requested != expected_next:
                return Response(
                    {"error": "invalid_transition", "expected": expected_next},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            order.status = expected_next
            if expected_next == Order.Status.COMPLETED:
                order.completed_at = timezone.now()
                order.save(update_fields=["status", "completed_at"])
                bill_completed_order(order)
            else:
                order.save(update_fields=["status"])

        broadcast_to_order(order.id, "order.status_changed", status=order.status)
        if expected_next == Order.Status.COMPLETED:
            notify(
                order.customer,
                "Buyurtma tugallandi",
                f"Buyurtma #{order.id} muvaffaqiyatli tugallandi. Iltimos, baholang.",
            )

        return Response(OrderSerializer(order).data)
