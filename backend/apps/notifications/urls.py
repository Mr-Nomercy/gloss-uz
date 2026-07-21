from django.urls import path

from .views import DeviceTokenView, NotificationListView, NotificationReadView

urlpatterns = [
    path("notifications/", NotificationListView.as_view(), name="notification-list"),
    path("notifications/<int:pk>/read/", NotificationReadView.as_view(), name="notification-read"),
    path("device-token/", DeviceTokenView.as_view(), name="device-token-register"),
]
