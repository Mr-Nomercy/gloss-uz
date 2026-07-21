from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("apps.core.urls")),
    path("api/v1/", include("apps.workforce.urls")),
    path("api/v1/auth/", include("apps.accounts.urls")),
    path("api/v1/", include("apps.catalog.urls")),
    path("api/v1/", include("apps.addresses.urls")),
    path("api/v1/", include("apps.orders.urls")),
    path("api/v1/dispatch/", include("apps.dispatch.urls")),
    path("api/v1/admin/", include("apps.admin_api.urls")),
    path("api/v1/", include("apps.notifications.urls")),
]
