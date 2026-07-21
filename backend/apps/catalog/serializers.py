from rest_framework import serializers

from .models import Addon, ServiceCategory, Tariff, TimeSlot


class AddonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Addon
        fields = ["id", "tariff", "name", "price"]


class TariffSerializer(serializers.ModelSerializer):
    addons = AddonSerializer(many=True, read_only=True)

    class Meta:
        model = Tariff
        fields = ["id", "service_category", "name", "base_price", "duration_min", "addons"]


class ServiceCategorySerializer(serializers.ModelSerializer):
    tariffs = TariffSerializer(many=True, read_only=True)

    class Meta:
        model = ServiceCategory
        fields = ["id", "name", "description", "tariffs"]


class TimeSlotSerializer(serializers.ModelSerializer):
    class Meta:
        model = TimeSlot
        fields = ["id", "date", "start_time", "end_time", "capacity"]
