from datetime import timedelta

from rest_framework_simplejwt.tokens import RefreshToken

# platform_admin holds the single highest-value credential in the system
# (admin_api grants everything) — a 30-day refresh token (the global
# SIMPLE_JWT default, sized for mobile apps that shouldn't force
# frequent re-login) is too long-lived for that risk. This overrides
# just the embedded exp claim, which simplejwt honors over the global
# setting on validation.
ADMIN_REFRESH_TOKEN_LIFETIME = timedelta(hours=8)


def issue_token_for_role(user, role, tenant_id=None):
    """Build a refresh token carrying the session's role + tenant scope."""
    token = RefreshToken.for_user(user)
    token["role"] = role
    token["tenant_id"] = tenant_id
    if role == "platform_admin":
        token.set_exp(lifetime=ADMIN_REFRESH_TOKEN_LIFETIME)
    return token


def issue_token_for_user(user):
    """Issue a token for an existing user, deriving role/tenant from their
    own UserRole row — never from client input (see M1 audit note: a
    client-supplied tenant_id here would be a tenant-impersonation path).

    MVP simplification: a user is expected to hold exactly one role.
    """
    role_obj = user.roles.first()
    if role_obj is None:
        raise ValueError(f"User {user.id} has no assigned role")
    return issue_token_for_role(user, role_obj.role, role_obj.tenant_id)
