from django.conf import settings
from django.contrib.gis.db import models as gis_models
from django.db import IntegrityError, models, transaction
from django.utils import timezone
from django.utils.crypto import get_random_string

from apps.core.models import TenantScopedModel


class Team(TenantScopedModel):
    class Status(models.TextChoices):
        AVAILABLE = "available", "Available"
        BUSY = "busy", "Busy"
        OFFLINE = "offline", "Offline"

    name = models.CharField(max_length=255)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.OFFLINE)
    rating_avg = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    location = gis_models.PointField(geography=True, null=True, blank=True, srid=4326)

    def __str__(self):
        return self.name


class WorkerProfile(TenantScopedModel):
    class Status(models.TextChoices):
        ACTIVE = "active", "Active"
        INACTIVE = "inactive", "Inactive"

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="worker_profile"
    )
    team = models.ForeignKey(
        Team, on_delete=models.SET_NULL, null=True, blank=True, related_name="members"
    )
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.ACTIVE)

    def __str__(self):
        return f"WorkerProfile({self.user_id})"


class WorkerInviteCode(TenantScopedModel):
    code = models.CharField(max_length=12, unique=True)
    is_used = models.BooleanField(default=False)
    used_by = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name="+"
    )
    expires_at = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)

    @classmethod
    def generate(cls, tenant, valid_for=timezone.timedelta(days=7), max_attempts=5):
        for _ in range(max_attempts):
            try:
                # Each attempt gets its own savepoint — an IntegrityError
                # on a collision must not poison the caller's outer
                # transaction (e.g. a request wrapped in ATOMIC_REQUESTS).
                with transaction.atomic():
                    return cls.all_tenants.create(
                        tenant=tenant,
                        code=get_random_string(8).upper(),
                        expires_at=timezone.now() + valid_for,
                    )
            except IntegrityError:
                continue
        raise IntegrityError("Could not generate a unique invite code after several attempts")

    def __str__(self):
        return self.code
