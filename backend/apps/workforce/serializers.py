from rest_framework import serializers

from .models import WorkerProfile


class WorkerProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkerProfile
        fields = ["id", "user", "team", "status", "tenant"]
