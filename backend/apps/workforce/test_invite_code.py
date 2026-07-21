from unittest.mock import patch

from django.test import TestCase
from django.utils import timezone

from apps.tenants.models import Tenant

from .models import WorkerInviteCode


class WorkerInviteCodeGenerationTests(TestCase):
    def setUp(self):
        self.tenant = Tenant.objects.create(name="Firma A", phone="+998900000001", city="Toshkent")

    def test_retries_on_code_collision(self):
        WorkerInviteCode.all_tenants.create(
            tenant=self.tenant,
            code="DUPLICAT",
            expires_at=timezone.now() + timezone.timedelta(days=7),
        )

        with patch(
            "apps.workforce.models.get_random_string",
            side_effect=["DUPLICAT", "UNIQUEONE"],
        ):
            invite = WorkerInviteCode.generate(self.tenant)

        self.assertEqual(invite.code, "UNIQUEONE")
