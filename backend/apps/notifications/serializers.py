from rest_framework import serializers

from apps.core.serializers import StringPKModelSerializer

from .models import DeviceToken, Notification


class NotificationSerializer(StringPKModelSerializer):
    class Meta:
        model = Notification
        fields = ["id", "title", "body", "type", "read_at", "created_at"]
        read_only_fields = fields


class DeviceTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = DeviceToken
        fields = ["token", "platform"]
