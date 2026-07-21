from django.db import connection
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import AccessToken

from .context import set_current_actor_id, set_current_tenant_id


class TenantContextMiddleware:
    """Resolves tenant + actor from the JWT and makes them available to
    the ORM (TenantScopedManager) and to Postgres RLS policies for the
    duration of the request.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        tenant_id = None
        actor_id = None

        auth_header = request.headers.get("Authorization", "")
        if auth_header.startswith("Bearer "):
            raw_token = auth_header.removeprefix("Bearer ").strip()
            try:
                token = AccessToken(raw_token)
                tenant_id = token.get("tenant_id")
                actor_id = token.get("user_id")
                request.jwt_role = token.get("role")
            except TokenError:
                request.jwt_role = None
        else:
            request.jwt_role = None

        set_current_tenant_id(tenant_id)
        set_current_actor_id(actor_id)
        self._set_db_session_tenant(tenant_id)

        try:
            return self.get_response(request)
        finally:
            set_current_tenant_id(None)
            set_current_actor_id(None)

    def _set_db_session_tenant(self, tenant_id):
        if connection.vendor != "postgresql":
            return
        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT set_config('app.current_tenant_id', %s, false)", [str(tenant_id or "")]
            )
