from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import WorkerProfile
from .serializers import WorkerProfileSerializer


class WorkerProfileViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = WorkerProfileSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Tenant scoping happens in TenantScopedManager.get_queryset(),
        # driven by the request's JWT — not by anything passed here.
        return WorkerProfile.objects.select_related("team").order_by("id")
