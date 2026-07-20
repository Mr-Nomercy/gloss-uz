from django.db import connection
from django.db.utils import OperationalError
from redis import Redis
from redis.exceptions import RedisError
from rest_framework.decorators import permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from django.conf import settings


@permission_classes([AllowAny])
class HealthCheckView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        checks = {"database": self._check_database(), "redis": self._check_redis()}
        status_code = 200 if all(checks.values()) else 503
        return Response({"status": "ok" if status_code == 200 else "degraded", "checks": checks}, status=status_code)

    def _check_database(self):
        try:
            connection.ensure_connection()
            return True
        except OperationalError:
            return False

    def _check_redis(self):
        try:
            redis_url = settings.CELERY_BROKER_URL
            client = Redis.from_url(redis_url, socket_connect_timeout=2)
            return client.ping()
        except RedisError:
            return False
