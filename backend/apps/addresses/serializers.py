from rest_framework import serializers

from .models import Address


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = ["id", "label", "raw_address", "city", "lat", "lng", "is_default", "created_at"]
        read_only_fields = ["id", "created_at"]
