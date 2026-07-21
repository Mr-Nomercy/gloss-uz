from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.accounts.models import Role, User
from apps.accounts.serializers import UserSerializer
from apps.accounts.tokens import issue_token_for_role
from apps.accounts.views import RefreshView as AdminRefreshView  # noqa: F401 (re-exported)


class AdminLoginView(APIView):
    """Email+password login for platform_admin — separate from the
    phone+OTP flow every other role uses (apps.accounts). tenant_admin
    isn't supported by the current gloss_admin build (platform-admin-only
    screens), so it's deliberately rejected here rather than issuing a
    token the UI has nowhere to use.
    """

    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")

        user = User.objects.filter(email=email).first()
        if user is None or not user.is_active or not user.check_password(password):
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
