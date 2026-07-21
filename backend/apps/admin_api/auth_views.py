from django.contrib.auth.hashers import check_password as check_password_hash
from django.contrib.auth.hashers import make_password
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.throttling import ScopedRateThrottle
from rest_framework.views import APIView

from apps.accounts.models import Role, User
from apps.accounts.serializers import UserSerializer
from apps.accounts.tokens import issue_token_for_role
from apps.accounts.views import RefreshView as AdminRefreshView  # noqa: F401 (re-exported)

# Computed once at import time, not per-request — used to give a
# nonexistent-email login attempt the same hash-comparison cost as a
# real one, so response timing can't be used to enumerate which emails
# have admin accounts (see AdminLoginView.post).
_DUMMY_PASSWORD_HASH = make_password("not-a-real-password-just-for-timing-safety")


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

        token = issue_token_for_role(user, role_obj.role, None)
        return Response(
            {
                "access_token": str(token.access_token),
                "refresh_token": str(token),
                "user": UserSerializer(user).data,
            }
        )
