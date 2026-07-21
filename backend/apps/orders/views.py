from rest_framework import mixins, status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.dispatch.models import DispatchQueue
from apps.realtime.broadcast import broadcast_to_order

from .models import Order
from .serializers import OrderCreateSerializer, OrderSerializer

REASON_REQUIRED_STATUSES = {Order.Status.ASSIGNED, Order.Status.EN_ROUTE, Order.Status.ARRIVED}
NOT_CANCELLABLE_STATUSES = {Order.Status.COMPLETED, Order.Status.RATED, Order.Status.CANCELLED}


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

        return Response(OrderSerializer(order).data)
