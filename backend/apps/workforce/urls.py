from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import WorkerInviteCodeView, WorkerProfileViewSet

router = DefaultRouter()
router.register("workers", WorkerProfileViewSet, basename="worker-profile")

urlpatterns = router.urls + [
    path("invite-codes", WorkerInviteCodeView.as_view(), name="worker-invite-codes"),
]
