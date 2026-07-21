from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from .views import (
    MarketingConsentView,
    OtpSendView,
    OtpVerifyView,
    RegisterView,
    WorkerRegisterView,
)

urlpatterns = [
    path("otp/send/", OtpSendView.as_view(), name="otp-send"),
    path("otp/verify/", OtpVerifyView.as_view(), name="otp-verify"),
    path("register/", RegisterView.as_view(), name="auth-register"),
    path("worker/register/", WorkerRegisterView.as_view(), name="auth-worker-register"),
    path("refresh/", TokenRefreshView.as_view(), name="auth-refresh"),
    path("marketing-consent/", MarketingConsentView.as_view(), name="auth-marketing-consent"),
]
