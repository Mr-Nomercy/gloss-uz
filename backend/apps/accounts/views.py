from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import RefreshToken

from apps.delivery.models import Courier
from apps.otp import services as otp_services
from apps.otp.models import OtpRequest
from apps.workforce.models import WorkerInviteCode, WorkerProfile

from .models import Role, User, UserRole
from .serializers import (
    OtpSendSerializer,
    OtpVerifySerializer,
    RegisterSerializer,
    UserSerializer,
    WorkerRegisterSerializer,
)
from .tokens import issue_token_for_role, issue_token_for_user
from .verification import issue_verified_token, read_verified_token

# Roles gloss_user/gloss_delivery can self-register into directly, no
# invite code needed (mirrors the frontend's UserRole vocabulary — see
# apps/accounts/role_mapping.py for the full backend<->frontend mapping).
_SELF_SERVICE_ROLES = {"client": Role.CUSTOMER, "courier": Role.COURIER}


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
            if user.is_blocked or not user.is_active:
                return Response({"error": "account_blocked"}, status=status.HTTP_403_FORBIDDEN)
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


class RefreshView(APIView):
    """Shared by every app's /auth/refresh — plain token refresh doesn't
    care which role the caller has. apps.admin_api reuses this directly
    rather than duplicating it.
    """

    permission_classes = [AllowAny]

    def post(self, request):
        # camelCase parser underscoreizes incoming keys: "refreshToken" -> "refresh_token".
        raw_token = request.data.get("refresh_token")
        if not raw_token:
            return Response(
                {"message": "refreshToken required"}, status=status.HTTP_400_BAD_REQUEST
            )
        try:
            token = RefreshToken(raw_token)
        except TokenError:
            return Response(
                {"message": "Token is invalid or expired"}, status=status.HTTP_401_UNAUTHORIZED
            )
        return Response({"access_token": str(token.access_token)})


class SimpleLoginView(APIView):
    """gloss_user/gloss_worker/gloss_delivery all call a single combined
    endpoint: {phone} to send the code, {phone, otp} to verify — unlike
    apps.accounts' own two-step otp/send + otp/verify. Kept separate
    rather than reshaping the original flow, since gloss_client (if it
    returns) may still expect the two-step version.
    """

    permission_classes = [AllowAny]

    def post(self, request):
        phone = request.data.get("phone")
        otp = request.data.get("otp")
        if not phone:
            return Response({"message": "phone required"}, status=status.HTTP_400_BAD_REQUEST)

        if not otp:
            otp_services.generate_and_send(phone, channel=OtpRequest.Channel.SMS)
            return Response({"sent": True})

        if not otp_services.verify(phone, otp):
            return Response({"message": "Kod noto'g'ri"}, status=status.HTTP_401_UNAUTHORIZED)

        user = User.objects.filter(phone=phone).first()
        if user is None:
            return Response({"message": "Ro'yxatdan o'tilmagan"}, status=status.HTTP_404_NOT_FOUND)
        if user.is_blocked or not user.is_active:
            return Response({"message": "Hisob bloklangan"}, status=status.HTTP_403_FORBIDDEN)

        token = issue_token_for_user(user)
        return Response(
            {
                "access_token": str(token.access_token),
                "refresh_token": str(token),
                "user": UserSerializer(user).data,
            }
        )


class SimpleRegisterView(APIView):
    """{phone, fullName, role} self-registration for gloss_user (client)
    and gloss_delivery (courier) — both platform-level roles with no
    tenant gate. gloss_worker's `role: "worker"` is deliberately rejected
    here rather than silently granted: tenant_worker requires an
    invite-code (see WorkerRegisterView) per the business rule that a
    worker must belong to a firm under contract. The current gloss_worker
    UI has no field to collect that code, so this returns a clear error
    instead of either 404ing or quietly bypassing the rule.
    """

    permission_classes = [AllowAny]

    def post(self, request):
        phone = request.data.get("phone")
        full_name = request.data.get("full_name")
        role = request.data.get("role")

        if not phone or not full_name or not role:
            return Response(
                {"message": "phone, fullName va role talab qilinadi"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        if User.objects.filter(phone=phone).exists():
            return Response({"message": "already_registered"}, status=status.HTTP_400_BAD_REQUEST)

        if role == "worker":
            return Response(
                {
                    "message": (
                        "Ishchi sifatida ro'yxatdan o'tish uchun firma bergan taklif "
                        "kodi kerak — hozircha bu ilovada bunday maydon yo'q."
                    )
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        backend_role = _SELF_SERVICE_ROLES.get(role)
        if backend_role is None:
            return Response(
                {"message": f"Noma'lum rol: {role}"}, status=status.HTTP_400_BAD_REQUEST
            )

        with transaction.atomic():
            user = User.objects.create_user(phone=phone, full_name=full_name)
            UserRole.objects.create(user=user, role=backend_role, tenant=None)
            if backend_role == Role.COURIER:
                Courier.objects.create(user=user)

        token = issue_token_for_role(user, backend_role, None)
        return Response(
            {
                "access_token": str(token.access_token),
                "refresh_token": str(token),
                "user": UserSerializer(user).data,
            },
            status=status.HTTP_201_CREATED,
        )
