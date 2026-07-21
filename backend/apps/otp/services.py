from django.contrib.auth.hashers import check_password, make_password
from django.utils import timezone
from django.utils.crypto import get_random_string

from .models import OtpRequest
from .providers import get_provider

CODE_TTL = timezone.timedelta(minutes=5)
MAX_ATTEMPTS = 5


class OtpError(Exception):
    pass


def _hash_code(code: str) -> str:
    # make_password is intentionally slow (bcrypt/pbkdf2); fine here since
    # verification is a low-QPS, human-paced action, not a hot path.
    return make_password(code)


def generate_and_send(phone: str, channel: str) -> OtpRequest:
    code = get_random_string(4, allowed_chars="0123456789")
    otp = OtpRequest.objects.create(
        phone=phone,
        channel=channel,
        code_hash=_hash_code(code),
        expires_at=timezone.now() + CODE_TTL,
    )
    get_provider(channel).send(phone, code)
    return otp


def verify(phone: str, code: str) -> bool:
    otp = (
        OtpRequest.objects.filter(phone=phone, verified_at__isnull=True)
        .order_by("-created_at")
        .first()
    )
    if otp is None:
        return False
    if otp.expires_at < timezone.now():
        return False
    if otp.attempts >= MAX_ATTEMPTS:
        return False

    otp.attempts += 1
    otp.save(update_fields=["attempts"])

    if not check_password(code, otp.code_hash):
        return False

    otp.verified_at = timezone.now()
    otp.save(update_fields=["verified_at"])
    return True
