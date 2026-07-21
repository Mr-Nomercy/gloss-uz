from rest_framework import serializers

from apps.otp.models import OtpRequest


class OtpSendSerializer(serializers.Serializer):
    phone = serializers.CharField(max_length=20)
    channel = serializers.ChoiceField(choices=OtpRequest.Channel.choices)


class OtpVerifySerializer(serializers.Serializer):
    phone = serializers.CharField(max_length=20)
    code = serializers.CharField(max_length=8)


class RegisterSerializer(serializers.Serializer):
    verified_token = serializers.CharField()
    full_name = serializers.CharField(max_length=255)
    marketing_consent = serializers.BooleanField(default=False)


class WorkerRegisterSerializer(serializers.Serializer):
    verified_token = serializers.CharField()
    invite_code = serializers.CharField(max_length=12)
    full_name = serializers.CharField(max_length=255)
