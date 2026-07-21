from datetime import timedelta
from pathlib import Path

import environ

BASE_DIR = Path(__file__).resolve().parent.parent.parent

env = environ.Env()
env_file = BASE_DIR / ".env"
if env_file.exists():
    environ.Env.read_env(str(env_file))

SECRET_KEY = env("SECRET_KEY", default="insecure-dev-key-change-me")
DEBUG = env.bool("DEBUG", default=False)
ALLOWED_HOSTS = env.list("ALLOWED_HOSTS", default=[])

INSTALLED_APPS = [
    "django.contrib.gis",
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "rest_framework_simplejwt",
    "corsheaders",
    "channels",
    "apps.core",
    "apps.accounts",
    "apps.tenants",
    "apps.workforce",
    "apps.otp",
    "apps.catalog",
    "apps.addresses",
    "apps.orders",
    "apps.dispatch",
    "apps.market",
    "apps.delivery",
    "apps.payments",
    "apps.admin_api",
    "apps.notifications",
]

PUSH_FORCE_CONSOLE_PROVIDER = env.bool("PUSH_FORCE_CONSOLE_PROVIDER", default=True)

OTP_FORCE_CONSOLE_PROVIDER = env.bool("OTP_FORCE_CONSOLE_PROVIDER", default=True)

AUTH_USER_MODEL = "accounts.User"

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "apps.core.middleware.TenantContextMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"
ASGI_APPLICATION = "config.asgi.application"

DATABASES = {
    "default": env.db("DATABASE_URL", default="postgis://gloss:gloss@localhost:5432/gloss"),
}

# Only consulted when DATABASE_URL uses the spatialite:// scheme (local
# dev/test fallback when Postgres+PostGIS isn't available) — ignored by
# the postgis backend used in Docker/prod.
SPATIALITE_LIBRARY_PATH = env("SPATIALITE_LIBRARY_PATH", default="mod_spatialite")

CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels_redis.core.RedisChannelLayer",
        "CONFIG": {
            "hosts": [env("REDIS_URL", default="redis://localhost:6379/0")],
        },
    },
}

CELERY_BROKER_URL = env("REDIS_URL", default="redis://localhost:6379/0")
CELERY_RESULT_BACKEND = env("REDIS_URL", default="redis://localhost:6379/0")
CELERY_BROKER_CONNECTION_RETRY_ON_STARTUP = True
CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

LANGUAGE_CODE = "uz"
TIME_ZONE = "Asia/Tashkent"
USE_I18N = True
USE_TZ = True

STATIC_URL = "static/"
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": ("apps.accounts.authentication.BlockAwareJWTAuthentication",),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
    "EXCEPTION_HANDLER": "apps.core.exceptions.exception_handler",
    # The Flutter apps (gloss_admin/user/worker/delivery) are hardcoded to
    # camelCase JSON keys — this translates automatically at the render/
    # parse boundary so serializers/models can stay idiomatic snake_case.
    "DEFAULT_RENDERER_CLASSES": ("djangorestframework_camel_case.render.CamelCaseJSONRenderer",),
    "DEFAULT_PARSER_CLASSES": ("djangorestframework_camel_case.parser.CamelCaseJSONParser",),
    # Real clients (Dio/Flutter) only ever send JSON bodies — match that
    # in tests too rather than DRF's browsable-API-oriented default of
    # multipart form, which the JSON-only parser above now rejects.
    "TEST_REQUEST_DEFAULT_FORMAT": "json",
    "DEFAULT_THROTTLE_RATES": {
        # platform_admin login is the single highest-value credential in
        # the system (grants everything in admin_api) and had zero
        # brute-force protection until this was added during audit.
        "admin-login": "5/min",
    },
}

CORS_ALLOWED_ORIGINS = env.list("CORS_ALLOWED_ORIGINS", default=[])

# Payme/Click merchant credentials — unset (empty) until the real
# contract with each gateway is signed. Checkout URL generation degrades
# gracefully with blank ids (just won't resolve to anything live);
# webhook signature checks fail closed when the secret is empty (see
# apps.payments.views), so no live traffic can be forged in the meantime.
PAYME_MERCHANT_ID = env("PAYME_MERCHANT_ID", default="")
PAYME_SECRET_KEY = env("PAYME_SECRET_KEY", default="")
CLICK_SERVICE_ID = env("CLICK_SERVICE_ID", default="")
CLICK_MERCHANT_ID = env("CLICK_MERCHANT_ID", default="")
CLICK_SECRET_KEY = env("CLICK_SECRET_KEY", default="")

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=15),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=30),
    "ROTATE_REFRESH_TOKENS": True,
}
