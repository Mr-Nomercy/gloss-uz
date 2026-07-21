from django.db import models

from apps.orders.models import Order
from apps.workforce.models import Team


class DispatchQueue(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"
        ACCEPTED = "accepted", "Accepted"
        TIMEOUT = "timeout", "Timeout"

    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name="dispatch_offers")
    team = models.ForeignKey(Team, on_delete=models.CASCADE, related_name="dispatch_offers")
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    is_winner = models.BooleanField(default=False)
    offered_at = models.DateTimeField(auto_now_add=True)
    responded_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ("order", "team")

    def __str__(self):
        return f"DispatchQueue(order={self.order_id}, team={self.team_id}, {self.status})"
