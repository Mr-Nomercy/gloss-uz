from django.db import models


class Tenant(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"
        ACTIVE = "active", "Active"
        SUSPENDED = "suspended", "Suspended"

    name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    city = models.CharField(max_length=100)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    contract_signed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class CommissionRule(models.Model):
    service_type = models.CharField(max_length=100)
    tenant = models.ForeignKey(
        Tenant, on_delete=models.CASCADE, null=True, blank=True, related_name="commission_rules"
    )
    percentage = models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        unique_together = ("service_type", "tenant")

    def __str__(self):
        return f"{self.service_type}:{self.percentage}%"
