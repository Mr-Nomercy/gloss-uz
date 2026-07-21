import logging
from abc import ABC, abstractmethod

logger = logging.getLogger("gloss.otp")


class OtpProvider(ABC):
    @abstractmethod
    def send(self, phone: str, code: str) -> None: ...


class ConsoleOtpProvider(OtpProvider):
    """Dev-only provider — logs the code instead of sending it.

    Used until real Telegram Gateway / SMS credentials exist.
    """

    def send(self, phone: str, code: str) -> None:
        logger.info("OTP for %s: %s", phone, code)


class TelegramGatewayProvider(OtpProvider):
    def send(self, phone: str, code: str) -> None:
        raise NotImplementedError("Telegram Gateway API credentials not configured yet")


class SmsProvider(OtpProvider):
    def send(self, phone: str, code: str) -> None:
        raise NotImplementedError("Eskiz/PlayMobile SMS API credentials not configured yet")


class FlashCallProvider(OtpProvider):
    def send(self, phone: str, code: str) -> None:
        raise NotImplementedError("Flash-call provider not configured yet")


_PROVIDERS = {
    "telegram": TelegramGatewayProvider,
    "sms": SmsProvider,
    "flash_call": FlashCallProvider,
}


def get_provider(channel: str) -> OtpProvider:
    from django.conf import settings

    if getattr(settings, "OTP_FORCE_CONSOLE_PROVIDER", False):
        return ConsoleOtpProvider()
    provider_class = _PROVIDERS.get(channel)
    if provider_class is None:
        raise ValueError(f"Unknown OTP channel: {channel}")
    return provider_class()
