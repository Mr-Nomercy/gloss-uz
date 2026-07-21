from .models import DeviceToken, Notification
from .providers import get_provider


def notify(user, title, body, notification_type=Notification.Type.SYSTEM):
    """Always writes the in-app Notification row; best-effort pushes to
    every device token the user has registered. A push provider failure
    (or simply having no registered device) never blocks the write —
    the in-app notification is the source of truth.
    """
    notification = Notification.objects.create(
        user=user, title=title, body=body, type=notification_type
    )

    provider = get_provider()
    for device in DeviceToken.objects.filter(user=user):
        provider.send(device.token, title, body)

    return notification
