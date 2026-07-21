from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import (
    DeliveryAssignmentAcceptView,
    DeliveryAssignmentStatusView,
    DeliveryAssignmentViewSet,
)

router = DefaultRouter()
router.register("assignments", DeliveryAssignmentViewSet, basename="delivery-assignment")

urlpatterns = router.urls + [
    path(
        "assignments/<int:pk>/accept/",
        DeliveryAssignmentAcceptView.as_view(),
        name="delivery-assignment-accept",
    ),
    path(
        "assignments/<int:pk>/status/",
        DeliveryAssignmentStatusView.as_view(),
        name="delivery-assignment-status",
    ),
]
