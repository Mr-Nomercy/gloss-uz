from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.otp import services as otp_services
from apps.workforce.models import WorkerInviteCode, WorkerProfile

from .models import Role, User, UserRole
from .serializers import (
    OtpSendSerializer,
    OtpVerifySerializer,
    RegisterSerializer,
    WorkerRegisterSerializer,
)
from .tokens import issue_token_for_role, issue_token_for_user
from .verification import issue_verified_token, read_verified_token


def _token_pair_response(token, status_code=status.HTTP_200_OK, extra=None):
    data = {"access": str(token.access_token), "refresh": str(token)}
    if extra:
        data.update(extra)
    return Response(data, status=status_code)


class OtpSendView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OtpSendSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        otp_services.generate_and_send(**serializer.validated_data)
        return Response({"sent": True})


class OtpVerifyView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = OtpVerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        phone = serializer.validated_data["phone"]
        code = serializer.validated_data["code"]

        if not otp_services.verify(phone, code):
            return Response(
                {"error": "invalid_or_expired_code"}, status=status.HTTP_400_BAD_REQUEST
            )

        user = User.objects.filter(phone=phone).first()
        if user is not None:
            token = issue_token_for_user(user)
            return _token_pair_response(token, extra={"status": "login"})

        return Response({"status": "new_user", "verified_token": issue_verified_token(phone)})


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        phone = read_verified_token(data["verified_token"])
        if phone is None:
            return Response(
                {"error": "invalid_or_expired_token"}, status=status.HTTP_400_BAD_REQUEST
            )
        if User.objects.filter(phone=phone).exists():
            return Response({"error": "already_registered"}, status=status.HTTP_400_BAD_REQUEST)

        with transaction.atomic():
            user = User.objects.create_user(
                phone=phone,
                full_name=data["full_name"],
                marketing_consent=data["marketing_consent"],
            )
            UserRole.objects.create(user=user, role=Role.CUSTOMER, tenant=None)

        token = issue_token_for_role(user, Role.CUSTOMER, None)
        return _token_pair_response(token, status.HTTP_201_CREATED, extra={"status": "registered"})


class WorkerRegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = WorkerRegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        phone = read_verified_token(data["verified_token"])
        if phone is None:
            return Response(
                {"error": "invalid_or_expired_token"}, status=status.HTTP_400_BAD_REQUEST
            )
        if User.objects.filter(phone=phone).exists():
            return Response({"error": "already_registered"}, status=status.HTTP_400_BAD_REQUEST)

        # Tenant context isn't established yet at this point in the flow
        # (no JWT on this request), so the invite code itself is the
        # authorization — looked up via the explicit cross-tenant manager.
        invite = WorkerInviteCode.all_tenants.filter(
            code=data["invite_code"], is_used=False, expires_at__gt=timezone.now()
        ).first()
        if invite is None:
            return Response(
                {"error": "invalid_or_expired_invite_code"}, status=status.HTTP_400_BAD_REQUEST
            )

        with transaction.atomic():
            user = User.objects.create_user(phone=phone, full_name=data["full_name"])
            UserRole.objects.create(user=user, role=Role.TENANT_WORKER, tenant=invite.tenant)
            WorkerProfile.all_tenants.create(tenant=invite.tenant, user=user)
            invite.is_used = True
            invite.used_by = user
            invite.save(update_fields=["is_used", "used_by"])

        token = issue_token_for_role(user, Role.TENANT_WORKER, invite.tenant_id)
        return _token_pair_response(token, status.HTTP_201_CREATED, extra={"status": "registered"})


class MarketingConsentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        consent = bool(request.data.get("consent", False))
        request.user.marketing_consent = consent
        request.user.save(update_fields=["marketing_consent"])
        return Response({"marketing_consent": consent})
