from django.conf import settings
from django.contrib.gis.db import models as gis_models
from django.db import models


class Courier(models.Model):
    """Platform-level delivery fleet — Gloss's own couriers, unrelated to
    any tenant's cleaning workers (see docs/12-END-TO-END-ROADMAP.md)."""

    class Status(models.TextChoices):
        AVAILABLE = "available", "Available"
        BUSY = "busy", "Busy"
        OFFLINE = "offline", "Offline"

    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="courier_profile"
    )
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.OFFLINE)
    location = gis_models.PointField(geography=True, null=True, blank=True, srid=4326)
    rating_avg = models.DecimalField(max_digits=3, decimal_places=2, default=0)

    def __str__(self):
        return f"Courier({self.user_id})"


class DeliveryAssignment(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"  # unclaimed, visible to eligible couriers
        ACCEPTED = "accepted", "Accepted"
        PICKED_UP = "picked_up", "Picked Up"
        DELIVERED = "delivered", "Delivered"
        CANCELLED = "cancelled", "Cancelled"

    market_order = models.OneToOneField(
        "market.MarketOrder", on_delete=models.CASCADE, related_name="delivery_assignment"
    )
    courier = models.ForeignKey(
        Courier, on_delete=models.SET_NULL, null=True, blank=True, related_name="assignments"
    )
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    created_at = models.DateTimeField(auto_now_add=True)
    assigned_at = models.DateTimeField(null=True, blank=True)
    picked_up_at = models.DateTimeField(null=True, blank=True)
    delivered_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"DeliveryAssignment(order={self.market_order_id}, {self.status})"
