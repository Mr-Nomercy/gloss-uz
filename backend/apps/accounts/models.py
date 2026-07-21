from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models


class UserManager(BaseUserManager):
    def create_user(self, phone, password=None, **extra_fields):
        if not phone:
            raise ValueError("Phone number is required")
        user = self.model(phone=phone, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, phone, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        return self.create_user(phone, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    phone = models.CharField(max_length=20, unique=True)
    full_name = models.CharField(max_length=255, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    marketing_consent = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    objects = UserManager()

    USERNAME_FIELD = "phone"
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.phone


class Role(models.TextChoices):
    PLATFORM_ADMIN = "platform_admin", "Platform Admin"
    TENANT_ADMIN = "tenant_admin", "Tenant Admin"
    TENANT_WORKER = "tenant_worker", "Tenant Worker"
    CUSTOMER = "customer", "Customer"
    COURIER = "courier", "Courier"


class UserRole(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="roles")
    role = models.CharField(max_length=20, choices=Role.choices)
    tenant = models.ForeignKey(
        "tenants.Tenant", on_delete=models.CASCADE, null=True, blank=True, related_name="user_roles"
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("user", "role", "tenant")

    def __str__(self):
        return f"{self.user_id}:{self.role}:{self.tenant_id}"
