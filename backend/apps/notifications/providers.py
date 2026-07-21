import logging
from abc import ABC, abstractmethod

logger = logging.getLogger("gloss.notifications")


class PushProvider(ABC):
    @abstractmethod
    def send(self, token: str, title: str, body: str) -> None: ...


class ConsolePushProvider(PushProvider):
    """Dev-only provider — logs instead of sending, since no real FCM
    service-account credentials exist yet (same situation as OTP).
    """

    def send(self, token: str, title: str, body: str) -> None:
        logger.info("Push to %s: %s — %s", token, title, body)


class FcmPushProvider(PushProvider):
    def send(self, token: str, title: str, body: str) -> None:
        raise NotImplementedError("Firebase Cloud Messaging credentials not configured yet")


def get_provider() -> PushProvider:
    from django.conf import settings

    if getattr(settings, "PUSH_FORCE_CONSOLE_PROVIDER", True):
        return ConsolePushProvider()
    return FcmPushProvider()
