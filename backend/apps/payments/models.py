from decimal import Decimal

from django.core.validators import MinValueValidator
from django.db import models


class Transaction(models.Model):
    class Provider(models.TextChoices):
        PAYME = "payme", "Payme"
        CLICK = "click", "Click"

    class Status(models.TextChoices):
        CREATED = "created", "Created"  # local row exists, gateway hasn't confirmed yet
        PENDING = "pending", "Pending"  # gateway acknowledged, awaiting perform/complete
        PAID = "paid", "Paid"
        CANCELLED = "cancelled", "Cancelled"

    market_order = models.ForeignKey(
        "market.MarketOrder", on_delete=models.CASCADE, related_name="transactions"
    )
    provider = models.CharField(max_length=10, choices=Provider.choices)
    # Payme's transaction id (params.id) / Click's click_trans_id — the
    # gateway's own identifier, distinct from this row's pk.
    external_id = models.CharField(max_length=255, blank=True, db_index=True)
    amount = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    status = models.CharField(max_length=10, choices=Status.choices, default=Status.CREATED)
    created_at = models.DateTimeField(auto_now_add=True)
    paid_at = models.DateTimeField(null=True, blank=True)
    cancelled_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"Transaction({self.provider}, order={self.market_order_id}, {self.status})"
