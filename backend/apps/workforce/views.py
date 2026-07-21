from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.core.context import get_current_tenant_id
from apps.core.permissions import IsTenantAdmin
from apps.tenants.models import Tenant

from .models import WorkerInviteCode, WorkerProfile
from .serializers import WorkerInviteCodeSerializer, WorkerProfileSerializer


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


class WorkerInviteCodeView(APIView):
    """tenant_admin generates the invite codes that WorkerRegisterView
    (apps.accounts) consumes — the other half of the M2 invite-code flow
    that only had a model + consumer until M5 gave tenant_admin a way to
    log in and actually call this.
    """

    permission_classes = [IsTenantAdmin]

    def get(self, request):
        codes = WorkerInviteCode.objects.order_by("-created_at")
        return Response(WorkerInviteCodeSerializer(codes, many=True).data)

    def post(self, request):
        # Tenant.objects (plain manager, platform-level model) — not the
        # tenant-scoped WorkerInviteCode manager — since we need the
        # Tenant instance itself to pass into generate().
        tenant = Tenant.objects.get(id=get_current_tenant_id())
        invite = WorkerInviteCode.generate(tenant)
        return Response(WorkerInviteCodeSerializer(invite).data, status=201)
