from rest_framework import serializers

from .models import WorkerInviteCode, WorkerProfile


class WorkerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkerProfile
        fields = ["id", "user", "team", "status", "tenant"]


class WorkerInviteCodeSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkerInviteCode
        fields = ["id", "code", "is_used", "expires_at", "created_at"]
