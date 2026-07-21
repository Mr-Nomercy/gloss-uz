from django.test import TestCase

from apps.accounts.models import User
from apps.core.context import set_current_actor_id
from apps.core.models import AuditLog

from .models import Tenant


class TenantAuditLogTests(TestCase):
    def test_tenant_creation_is_logged_with_actor(self):
        actor = User.objects.create_user(phone="+998900000099")

        set_current_actor_id(actor.id)
        try:
            tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")
        finally:
            set_current_actor_id(None)

        log = AuditLog.objects.get(target_model="Tenant", target_id=str(tenant.id))
        self.assertEqual(log.action, "tenant.created")
        self.assertEqual(log.actor_id, actor.id)
        self.assertEqual(log.after["status"], Tenant.Status.PENDING)

    def test_tenant_update_is_logged_as_updated(self):
        tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")

        tenant.status = Tenant.Status.ACTIVE
        tenant.save()

        log = AuditLog.objects.filter(target_model="Tenant", target_id=str(tenant.id)).latest(
            "created_at"
        )
        self.assertEqual(log.action, "tenant.updated")
        self.assertEqual(log.after["status"], Tenant.Status.ACTIVE)
