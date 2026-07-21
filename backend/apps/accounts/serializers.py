from rest_framework import serializers

from apps.core.serializers import StringPKModelSerializer
from apps.otp.models import OtpRequest

from .models import User
from .role_mapping import frontend_roles_for_user


class UserSerializer(StringPKModelSerializer):
    roles = serializers.SerializerMethodField()
    avatar = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "phone",
            "email",
            "full_name",
            "avatar",
            "roles",
            "is_blocked",
            "created_at",
        ]

    def get_roles(self, user):
        return frontend_roles_for_user(user)

    def get_avatar(self, user):
        return None


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
