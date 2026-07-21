from django.db.models.signals import post_save
from django.dispatch import receiver

from apps.core.context import get_current_actor_id
from apps.core.models import AuditLog

from .models import Tenant


@receiver(post_save, sender=Tenant)
def log_tenant_change(sender, instance, created, **kwargs):
    AuditLog.objects.create(
        actor_id=get_current_actor_id(),
        action="tenant.created" if created else "tenant.updated",
        target_model="Tenant",
        target_id=str(instance.pk),
        after={"name": instance.name, "status": instance.status},
    )
