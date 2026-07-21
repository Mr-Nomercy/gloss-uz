from django.conf import settings
from django.db import models

from .context import get_current_tenant_id


class TenantScopedManager(models.Manager):
    """Default manager — always filtered to the request's tenant.

    Returns nothing if no tenant is in context, rather than leaking
    cross-tenant rows to a caller that forgot to scope the query.
    """

    def get_queryset(self):
        qs = super().get_queryset()
        tenant_id = get_current_tenant_id()
        if tenant_id is None:
            return qs.none()
        return qs.filter(tenant_id=tenant_id)


class TenantUnscopedManager(models.Manager):
    """Explicit escape hatch for platform_admin cross-tenant views."""


class TenantScopedModel(models.Model):
    tenant = models.ForeignKey("tenants.Tenant", on_delete=models.CASCADE)

    objects = TenantScopedManager()
    all_tenants = TenantUnscopedManager()

    class Meta:
        abstract = True
        # Django uses the base manager (not `objects`) for things like
        # forward FK descriptor lookups (`some_offer.team`), cascade
        # deletes, etc. Without this, those internal lookups would go
        # through TenantScopedManager and silently return nothing (or
        # raise) whenever the current request's tenant context doesn't
        # happen to match — a trap for any code that isn't a direct,
        # deliberate `Team.objects.filter(...)` call.
        base_manager_name = "all_tenants"


class AuditLog(models.Model):
    actor = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, related_name="audit_logs"
    )
    action = models.CharField(max_length=100)
    target_model = models.CharField(max_length=100)
    target_id = models.CharField(max_length=100)
    before = models.JSONField(null=True, blank=True)
    after = models.JSONField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.action}:{self.target_model}:{self.target_id}"
