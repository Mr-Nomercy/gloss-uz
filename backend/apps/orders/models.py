from decimal import Decimal

from django.conf import settings
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models

from apps.addresses.models import Address
from apps.catalog.models import Addon, Tariff
from apps.tenants.models import Tenant
from apps.workforce.models import Team


class Order(models.Model):
    class Status(models.TextChoices):
        SEARCHING = "searching", "Searching"
        ASSIGNED = "assigned", "Assigned"
        EN_ROUTE = "en_route", "En Route"
        ARRIVED = "arrived", "Arrived"
        IN_PROGRESS = "in_progress", "In Progress"
        COMPLETED = "completed", "Completed"
        RATED = "rated", "Rated"
        CANCELLED = "cancelled", "Cancelled"

    customer = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="orders"
    )
    # Null until a team accepts the offer in M3 — an order isn't owned by
    # any one tenant until dispatch assigns it, so this is a plain nullable
    # FK rather than TenantScopedModel (that scoping doesn't apply pre-assignment).
    tenant = models.ForeignKey(
        Tenant, on_delete=models.SET_NULL, null=True, blank=True, related_name="orders"
    )
    # Same story as tenant — null until AcceptOfferView assigns a winner.
    # Tracked separately from tenant because a tenant can run multiple
    # teams; only the specific team that won dispatch may progress this
    # order's status.
    team = models.ForeignKey(
        Team, on_delete=models.SET_NULL, null=True, blank=True, related_name="orders"
    )
    tariff = models.ForeignKey(Tariff, on_delete=models.PROTECT, related_name="orders")
    addons = models.ManyToManyField(Addon, blank=True, related_name="orders")
    address = models.ForeignKey(Address, on_delete=models.PROTECT, related_name="orders")
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.SEARCHING)
    scheduled_time = models.DateTimeField()
    total_price = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    commission_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(Decimal(0))],
    )
    net_amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(Decimal(0))],
    )
    created_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"Order({self.id}, {self.status})"


class Review(models.Model):
    order = models.OneToOneField(Order, on_delete=models.CASCADE, related_name="review")
    customer = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="reviews_given"
    )
    team = models.ForeignKey(
        Team, on_delete=models.SET_NULL, null=True, blank=True, related_name="reviews"
    )
    aspect_quality = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    aspect_punctuality = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    aspect_communication = models.PositiveSmallIntegerField(
        validators=[MinValueValidator(1), MaxValueValidator(5)]
    )
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Review(order={self.order_id})"
