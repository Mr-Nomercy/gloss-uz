from rest_framework_simplejwt.tokens import RefreshToken


def issue_token_for_role(user, role, tenant_id=None):
    """Build a refresh token carrying the session's role + tenant scope.

    Full OTP-based login lands in M2; this is the shared claim-embedding
    path both the future login view and tests use.
    """
    token = RefreshToken.for_user(user)
    token["role"] = role
    token["tenant_id"] = tenant_id
    return token
