from rest_framework import serializers

from apps.addresses.models import Address
from apps.catalog.models import Addon, Tariff

from .models import Order


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = [
            "id",
            "tenant",
            "tariff",
            "addons",
            "address",
            "status",
            "scheduled_time",
            "total_price",
            "commission_amount",
            "net_amount",
            "created_at",
            "completed_at",
        ]
        read_only_fields = fields


class OrderCreateSerializer(serializers.Serializer):
    tariff_id = serializers.PrimaryKeyRelatedField(queryset=Tariff.objects.all(), source="tariff")
    addon_ids = serializers.PrimaryKeyRelatedField(
        queryset=Addon.objects.all(), source="addons", many=True, required=False, default=[]
    )
    address_id = serializers.PrimaryKeyRelatedField(
        queryset=Address.objects.all(), source="address"
    )
    scheduled_time = serializers.DateTimeField()

    def validate(self, attrs):
        request = self.context["request"]

        if attrs["address"].user_id != request.user.id:
            raise serializers.ValidationError({"address_id": "Not your address."})

        tariff = attrs["tariff"]
        for addon in attrs["addons"]:
            if addon.tariff_id != tariff.id:
                raise serializers.ValidationError(
                    {"addon_ids": f"Addon {addon.id} does not belong to this tariff."}
                )

        return attrs

    def create(self, validated_data):
        addons = validated_data.pop("addons", [])
        tariff = validated_data["tariff"]
        total_price = tariff.base_price + sum(addon.price for addon in addons)

        order = Order.objects.create(
            customer=self.context["request"].user,
            tariff=tariff,
            address=validated_data["address"],
            scheduled_time=validated_data["scheduled_time"],
            total_price=total_price,
        )
        if addons:
            order.addons.set(addons)

        from apps.dispatch.services import dispatch_order

        dispatch_order(order)
        return order
