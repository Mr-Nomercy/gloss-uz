from rest_framework_simplejwt.tokens import RefreshToken


def issue_token_for_role(user, role, tenant_id=None):
    """Build a refresh token carrying the session's role + tenant scope."""
    token = RefreshToken.for_user(user)
    token["role"] = role
    token["tenant_id"] = tenant_id
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
