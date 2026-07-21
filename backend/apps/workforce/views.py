from rest_framework import viewsets

from apps.core.permissions import IsTenantAdmin

from .models import WorkerProfile
from .serializers import WorkerProfileSerializer


class WorkerProfileViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = WorkerProfileSerializer
    permission_classes = [IsTenantAdmin]

    # NOTE: platform_admin is deliberately NOT allowed here. Their token
    # carries no tenant_id, so TenantScopedManager.objects would just
    # return an empty queryset for them anyway (fails closed by design).
    # Cross-tenant worker browsing for platform_admin needs its own
    # endpoint built on WorkerProfile.all_tenants, added when that
    # admin-panel feature is actually built (M5).

    def get_queryset(self):
        # Tenant scoping happens in TenantScopedManager.get_queryset(),
        # driven by the request's JWT — not by anything passed here.
        return WorkerProfile.objects.select_related("team").order_by("id")
