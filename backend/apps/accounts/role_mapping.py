from .models import Role

# Backend Role values -> the frontend's UserRole strings (packages/shared/
# constants/lib/constants.dart). Different vocabularies on each side —
# this is the single place that translates between them for user-facing
# JSON (the `roles` list on the User model Flutter deserializes).
_FRONTEND_ROLES = {
    Role.PLATFORM_ADMIN: ["admin", "super_admin"],
    Role.TENANT_ADMIN: ["tenant_admin"],
    Role.TENANT_WORKER: ["worker"],
    Role.CUSTOMER: ["client"],
    Role.COURIER: ["courier"],
}


def frontend_roles_for_user(user):
    roles = []
    for role in user.roles.values_list("role", flat=True):
        roles.extend(_FRONTEND_ROLES.get(role, [role]))
    return roles
