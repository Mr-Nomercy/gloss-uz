from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import AuthenticationFailed


class BlockAwareJWTAuthentication(JWTAuthentication):
    """Stock JWTAuthentication.get_user() already rejects is_active=False.
    admin_api's "block user" toggle sets User.is_blocked, a separate flag
    — found during audit that nothing anywhere actually checked it, so
    blocking a user from the admin panel had zero real effect on their
    API access. This is the same enforcement point Django already
    trusts for is_active, extended to also cover is_blocked.
    """

    def get_user(self, validated_token):
        user = super().get_user(validated_token)
        if user.is_blocked:
            raise AuthenticationFailed("Foydalanuvchi bloklangan", code="user_blocked")
        return user
