from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("apps.core.urls")),
    path("api/", include("apps.workforce.urls")),
    path("api/auth/", include("apps.accounts.urls")),
    path("api/", include("apps.catalog.urls")),
    path("api/", include("apps.addresses.urls")),
    path("api/", include("apps.orders.urls")),
    path("api/dispatch/", include("apps.dispatch.urls")),
]
