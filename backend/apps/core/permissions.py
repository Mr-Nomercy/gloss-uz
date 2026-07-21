from rest_framework.permissions import BasePermission


class IsPlatformAdmin(BasePermission):
    def has_permission(self, request, view):
        return getattr(request, "jwt_role", None) == "platform_admin"


class IsTenantAdmin(BasePermission):
    def has_permission(self, request, view):
        return getattr(request, "jwt_role", None) == "tenant_admin"
