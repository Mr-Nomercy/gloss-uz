from decimal import Decimal

from django.core.validators import MinValueValidator
from django.db import models


class ServiceCategory(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)

    class Meta:
        verbose_name_plural = "service categories"

    def __str__(self):
        return self.name


class Tariff(models.Model):
    service_category = models.ForeignKey(
        ServiceCategory, on_delete=models.CASCADE, related_name="tariffs"
    )
    name = models.CharField(max_length=255)
    base_price = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )
    duration_min = models.PositiveIntegerField()

    def __str__(self):
        return f"{self.service_category.name}:{self.name}"


class Addon(models.Model):
    tariff = models.ForeignKey(Tariff, on_delete=models.CASCADE, related_name="addons")
    name = models.CharField(max_length=255)
    price = models.DecimalField(
        max_digits=12, decimal_places=2, validators=[MinValueValidator(Decimal(0))]
    )

    def __str__(self):
        return self.name


class TimeSlot(models.Model):
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    capacity = models.PositiveIntegerField(default=1)

    class Meta:
        unique_together = ("date", "start_time", "end_time")
        ordering = ["date", "start_time"]

    def __str__(self):
        return f"{self.date} {self.start_time}-{self.end_time}"
