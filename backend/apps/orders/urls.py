from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import OrderViewSet, WorkerOrderStatusView

router = DefaultRouter()
router.register("orders", OrderViewSet, basename="order")

urlpatterns = router.urls + [
    path(
        "worker/orders/<int:pk>/status/",
        WorkerOrderStatusView.as_view(),
        name="worker-order-status",
    ),
]
