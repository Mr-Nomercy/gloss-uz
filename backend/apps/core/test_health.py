from rest_framework.test import APITestCase


class HealthCheckTests(APITestCase):
    def test_health_endpoint_reachable(self):
        response = self.client.get("/health/")
        self.assertIn(response.status_code, (200, 503))
        self.assertIn("status", response.json())
