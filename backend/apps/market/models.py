from decimal import Decimal

from django.conf import settings
from django.core.validators import MinValueValidator
from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=255)
    parent = models.ForeignKey(
        "self", on_delete=models.SET_NULL, null=True, blank=True, related_name="children"
    )

    class Meta:
        verbose_name_plural = "categories"

    def __str__(self):
        return self.name


class Product(models.Model):
    # Product Owner = Gloss itself (see docs/12-END-TO-END-ROADMAP.md) — no
    # seller FK. Only platform_admin ever writes to this model.
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    price = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    sale_price = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        null=True,
        blank=True,
        validators=[MinValueValidator(Decimal(0))],
    )
    stock_qty = models.PositiveIntegerField(default=0)
    category = models.ForeignKey(
        Category, on_delete=models.SET_NULL, null=True, blank=True, related_name="products"
    )
    rating = models.DecimalField(max_digits=3, decimal_places=2, default=0)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class ProductImage(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name="images")
    url = models.URLField()

    def __str__(self):
        return self.url


class Cart(models.Model):
    customer = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="cart"
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Cart({self.customer_id})"


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name="+")
    qty = models.PositiveIntegerField(default=1)

    class Meta:
        unique_together = ("cart", "product")

    def __str__(self):
        return f"CartItem({self.product_id} x{self.qty})"


class MarketOrder(models.Model):
    class Status(models.TextChoices):
        PENDING = "pending", "Pending"  # cash: skipped; payme/click: awaiting webhook
        CONFIRMED = "confirmed", "Confirmed"  # paid/accepted, awaiting courier dispatch
        ASSIGNED_COURIER = "assigned_courier", "Assigned Courier"
        PICKED_UP = "picked_up", "Picked Up"
        DELIVERED = "delivered", "Delivered"
        CANCELLED = "cancelled", "Cancelled"

    class PaymentMethod(models.TextChoices):
        CASH = "cash", "Cash"
        PAYME = "payme", "Payme"
        CLICK = "click", "Click"

    # Platform-level, no tenant_id — Product Owner is Gloss itself, this
    # has no relation to any tenant's cleaning workers (see roadmap's
    # Market/Delivery section).
    customer = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="market_orders"
    )
    address = models.ForeignKey(
        "addresses.Address", on_delete=models.PROTECT, related_name="market_orders"
    )
    status = models.CharField(max_length=20, choices=Status.choices, default=Status.PENDING)
    payment_method = models.CharField(max_length=10, choices=PaymentMethod.choices)
    total_price = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ["-created_at"]

    def __str__(self):
        return f"MarketOrder({self.id}, {self.status})"


class MarketOrderItem(models.Model):
    market_order = models.ForeignKey(MarketOrder, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.PROTECT, related_name="+")
    qty = models.PositiveIntegerField()
    # Snapshot at checkout time — Product.price can change later without
    # rewriting historical orders.
    unit_price = models.DecimalField(max_digits=12, decimal_places=2)

    def __str__(self):
        return f"MarketOrderItem(order={self.market_order_id}, product={self.product_id})"
