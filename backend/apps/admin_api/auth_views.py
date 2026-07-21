import pyotp
from django.contrib.auth.hashers import check_password as check_password_hash
from django.contrib.auth.hashers import make_password
from django.utils import timezone
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.throttling import ScopedRateThrottle
from rest_framework.views import APIView

from apps.accounts.models import Role, User
from apps.accounts.serializers import UserSerializer
from apps.accounts.tokens import issue_token_for_role
from apps.accounts.views import RefreshView as AdminRefreshView  # noqa: F401 (re-exported)

from . import totp as totp_tokens

# Computed once at import time, not per-request — used to give a
# nonexistent-email login attempt the same hash-comparison cost as a
# real one, so response timing can't be used to enumerate which emails
# have admin accounts (see AdminLoginView.post).
_DUMMY_PASSWORD_HASH = make_password("not-a-real-password-just-for-timing-safety")


def _token_response(user):
    token = issue_token_for_role(user, "platform_admin", None)
    return Response(
        {
            "access_token": str(token.access_token),
            "refresh_token": str(token),
            "user": UserSerializer(user).data,
        }
    )


class AdminLoginView(APIView):
    """Email+password login for platform_admin — separate from the
    phone+OTP flow every other role uses (apps.accounts). tenant_admin
    isn't supported by the current gloss_admin build (platform-admin-only
    screens), so it's deliberately rejected here rather than issuing a
    token the UI has nowhere to use.
    """

    permission_classes = [AllowAny]
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "admin-login"

    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")

        user = User.objects.filter(email=email).first()
        if user is None:
            # Still run a (failing) hash check so a missing-vs-wrong-password
            # response takes the same time either way — otherwise the
            # early-exit here is a timing side channel an attacker can use
            # to enumerate which emails have admin accounts at all.
            check_password_hash(password or "", _DUMMY_PASSWORD_HASH)
            return Response(
                {"message": "Email yoki parol noto'g'ri"}, status=status.HTTP_401_UNAUTHORIZED
            )
        if not user.is_active or user.is_blocked or not user.check_password(password):
            return Response(
                {"message": "Email yoki parol noto'g'ri"}, status=status.HTTP_401_UNAUTHORIZED
            )

        role_obj = user.roles.filter(role=Role.PLATFORM_ADMIN).first()
        if role_obj is None:
            return Response(
                {"message": "Ruxsat yo'q. Admin panelga faqat adminlar kira oladi."},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        # 2FA is mandatory for platform_admin (highest-value credential
        # in the system) — password alone never completes a login here.
        if user.totp_confirmed_at is None:
            if not user.totp_secret:
                user.totp_secret = pyotp.random_base32()
                user.save(update_fields=["totp_secret"])
            return Response(
                {
                    "totp_setup_required": True,
                    "setup_token": totp_tokens.issue_setup_token(user.id),
                    "secret": user.totp_secret,
                    "otpauth_url": pyotp.TOTP(user.totp_secret).provisioning_uri(
                        name=user.email, issuer_name="Gloss Admin"
                    ),
                }
            )

        return Response({"totp_required": True, "mfa_token": totp_tokens.issue_mfa_token(user.id)})


class AdminTotpConfirmView(APIView):
    """Completes first-time TOTP enrollment: the setup_token from
    AdminLoginView proves password auth already succeeded, so a valid
    code here both enables 2FA and finishes the login in one step.
    """

    permission_classes = [AllowAny]
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "admin-login"

    def post(self, request):
        user_id = totp_tokens.read_setup_token(request.data.get("setup_token") or "")
        if user_id is None:
            return Response(
                {"message": "Sozlash muddati tugagan, qaytadan urinib ko'ring"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        user = User.objects.filter(id=user_id).first()
        if user is None or not user.totp_secret or user.totp_confirmed_at is not None:
            return Response({"message": "Noto'g'ri so'rov"}, status=status.HTTP_400_BAD_REQUEST)

        code = request.data.get("code") or ""
        if not pyotp.TOTP(user.totp_secret).verify(code):
            return Response({"message": "Kod noto'g'ri"}, status=status.HTTP_401_UNAUTHORIZED)

        user.totp_confirmed_at = timezone.now()
        user.save(update_fields=["totp_confirmed_at"])
        return _token_response(user)


class AdminTotpVerifyView(APIView):
    """Second factor for a platform_admin who already has 2FA enabled —
    the mfa_token from AdminLoginView identifies who's completing login."""

    permission_classes = [AllowAny]
    throttle_classes = [ScopedRateThrottle]
    throttle_scope = "admin-login"

    def post(self, request):
        user_id = totp_tokens.read_mfa_token(request.data.get("mfa_token") or "")
        if user_id is None:
            return Response(
                {"message": "Sessiya muddati tugagan, qaytadan kiring"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        user = User.objects.filter(id=user_id).first()
        if user is None or not user.totp_secret or user.totp_confirmed_at is None:
            return Response({"message": "Noto'g'ri so'rov"}, status=status.HTTP_400_BAD_REQUEST)

        code = request.data.get("code") or ""
        if not pyotp.TOTP(user.totp_secret).verify(code):
            return Response({"message": "Kod noto'g'ri"}, status=status.HTTP_401_UNAUTHORIZED)

        return _token_response(user)
