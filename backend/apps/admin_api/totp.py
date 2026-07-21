from django.core import signing

# Short-lived signed tokens that identify a platform_admin mid-login,
# without granting any API access themselves (they're not JWTs, nothing
# in the app accepts them as an Authorization bearer token) — the code
# entered against them is what actually proves the second factor.
_SETUP_SALT = "admin-2fa-setup"
_MFA_SALT = "admin-2fa-mfa"
_MAX_AGE = 300  # 5 minutes to finish either step after password auth


def issue_setup_token(user_id: int) -> str:
    return signing.dumps({"user_id": user_id}, salt=_SETUP_SALT)


def read_setup_token(token: str) -> int | None:
    try:
        payload = signing.loads(token, salt=_SETUP_SALT, max_age=_MAX_AGE)
    except signing.BadSignature:
        return None
    return payload.get("user_id")


def issue_mfa_token(user_id: int) -> str:
    return signing.dumps({"user_id": user_id}, salt=_MFA_SALT)


def read_mfa_token(token: str) -> int | None:
    try:
        payload = signing.loads(token, salt=_MFA_SALT, max_age=_MAX_AGE)
    except signing.BadSignature:
        return None
    return payload.get("user_id")
