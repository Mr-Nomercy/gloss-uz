from django.urls import path

from .views import (
    MarketingConsentView,
    OtpSendView,
    OtpVerifyView,
    RefreshView,
    RegisterView,
    SimpleLoginView,
    SimpleRegisterView,
    WorkerRegisterView,
)

urlpatterns = [
    # Two-step flow (verified_token -> register), used by whichever app
    # collects full_name/invite_code as a separate step after OTP.
    path("otp/send/", OtpSendView.as_view(), name="otp-send"),
    path("otp/verify/", OtpVerifyView.as_view(), name="otp-verify"),
    path("register/", RegisterView.as_view(), name="auth-register"),
    path("worker/register/", WorkerRegisterView.as_view(), name="auth-worker-register"),
    path("marketing-consent/", MarketingConsentView.as_view(), name="auth-marketing-consent"),
    # Combined flow — gloss_user/gloss_worker/gloss_delivery call these
    # exact paths (no trailing slash) with {phone}/{phone,otp} and
    # {phone, fullName, role} respectively.
    path("login", SimpleLoginView.as_view(), name="auth-login"),
    path("register", SimpleRegisterView.as_view(), name="auth-register-simple"),
    path("refresh", RefreshView.as_view(), name="auth-refresh"),
    path("refresh/", RefreshView.as_view(), name="auth-refresh-slash"),
]
