from rest_framework import serializers

from .models import DeliveryAssignment


class DeliveryAssignmentSerializer(serializers.ModelSerializer):
    address = serializers.CharField(source="market_order.address.raw_address", read_only=True)
    total_price = serializers.DecimalField(
        source="market_order.total_price", max_digits=12, decimal_places=2, read_only=True
    )

    class Meta:
        model = DeliveryAssignment
        fields = [
            "id",
            "market_order",
            "address",
            "total_price",
            "courier",
            "status",
            "created_at",
            "assigned_at",
            "picked_up_at",
            "delivered_at",
        ]
        read_only_fields = fields
