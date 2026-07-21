from django.core import signing

SALT = "otp-verified-phone"
MAX_AGE = 600  # 10 minutes to complete registration after OTP verification


def issue_verified_token(phone: str) -> str:
    return signing.dumps({"phone": phone}, salt=SALT)


def read_verified_token(token: str) -> str | None:
    try:
        payload = signing.loads(token, salt=SALT, max_age=MAX_AGE)
    except signing.BadSignature:
        return None
    return payload.get("phone")
