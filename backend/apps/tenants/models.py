from decimal import Decimal

from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models


class Tenant(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"
        ACTIVE = "active", "Active"
        SUSPENDED = "suspended", "Suspended"

    name = models.CharField(max_length=255)
    phone = models.CharField(max_length=20)
    email = models.EmailField(null=True, blank=True)
    city = models.CharField(max_length=100)
    logo_url = models.URLField(null=True, blank=True)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    # Per-tenant override shown/edited on the admin "tenant detail" screen —
    # distinct from CommissionRule below, which drives the platform-wide
    # per-service-type rates on the separate "commissions" admin screen.
    commission_rate = models.DecimalField(
        max_digits=4,
        decimal_places=2,
        default=Decimal("0.15"),
        validators=[MinValueValidator(Decimal(0)), MaxValueValidator(Decimal(1))],
    )
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    is_verified = models.BooleanField(default=False)
    contract_signed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class CommissionRule(models.Model):
    service_type = models.CharField(max_length=100)
    tenant = models.ForeignKey(
        Tenant, on_delete=models.CASCADE, null=True, blank=True, related_name="commission_rules"
    )
    percentage = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        validators=[MinValueValidator(Decimal(0)), MaxValueValidator(Decimal(100))],
    )
    min_order_amount = models.DecimalField(max_digits=12, decimal_places=2, default=30000)

    class Meta:
        unique_together = ("service_type", "tenant")

    def __str__(self):
        return f"{self.service_type}:{self.percentage}%"


class Wallet(models.Model):
    tenant = models.OneToOneField(Tenant, on_delete=models.CASCADE, related_name="wallet")
    balance = models.DecimalField(max_digits=14, decimal_places=2, default=0)

    def __str__(self):
        return f"Wallet({self.tenant_id}): {self.balance}"


class Transaction(models.Model):
    class Type(models.TextChoices):
        COMMISSION_CREDIT = "commission_credit", "Commission Credit"
        PAYOUT = "payout", "Payout"
        ADJUSTMENT = "adjustment", "Adjustment"

    wallet = models.ForeignKey(Wallet, on_delete=models.CASCADE, related_name="transactions")
    order = models.ForeignKey(
        "orders.Order",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="transactions",
    )
    type = models.CharField(max_length=20, choices=Type.choices)
    amount = models.DecimalField(max_digits=14, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Transaction({self.wallet_id}, {self.type}, {self.amount})"


class Payout(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"
        APPROVED = "approved", "Approved"
        REJECTED = "rejected", "Rejected"

    tenant = models.ForeignKey(Tenant, on_delete=models.CASCADE, related_name="payouts")
    amount = models.DecimalField(
        max_digits=14, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    card_number = models.CharField(max_length=32)
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    admin_note = models.TextField(null=True, blank=True)
    processed_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Payout({self.id}, {self.tenant_id}, {self.status})"
