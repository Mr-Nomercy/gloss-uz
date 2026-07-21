from rest_framework.test import APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.market.models import MarketOrder

from .models import Courier, DeliveryAssignment
from .services import dispatch_market_order


class DeliveryAssignmentFlowTests(APITestCase):
    """M6 gate: a confirmed MarketOrder becomes a claimable delivery
    assignment, one courier can claim it, and it progresses through
    picked_up -> delivered, keeping the MarketOrder's status in sync."""

    def setUp(self):
        customer = User.objects.create_user(phone="+998911111111")
        address = Address.objects.create(
            user=customer, raw_address="X", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = MarketOrder.objects.create(
            customer=customer,
            address=address,
            status=MarketOrder.Status.CONFIRMED,
            payment_method=MarketOrder.PaymentMethod.CASH,
            total_price="25000.00",
        )
        self.assignment = dispatch_market_order(self.order)

        self.courier_user = User.objects.create_user(phone="+998933333333")
        self.courier_user.roles.create(role=Role.COURIER, tenant=None)
        self.courier_profile = Courier.objects.create(user=self.courier_user)
        courier_token = issue_token_for_role(self.courier_user, "courier", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {courier_token.access_token}")

    def test_courier_sees_pending_assignment(self):
        response = self.client.get("/api/v1/delivery/assignments/")
        self.assertEqual(response.status_code, 200, response.data)
        results = response.data["results"]
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0]["status"], DeliveryAssignment.Status.PENDING)

    def test_accept_then_progress_to_delivered(self):
        accept_response = self.client.post(
            f"/api/v1/delivery/assignments/{self.assignment.id}/accept/"
        )
        self.assertEqual(accept_response.status_code, 200, accept_response.data)
        self.assertEqual(accept_response.data["status"], DeliveryAssignment.Status.ACCEPTED)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.ASSIGNED_COURIER)
        self.courier_profile.refresh_from_db()
        self.assertEqual(self.courier_profile.status, Courier.Status.BUSY)

        picked_up_response = self.client.patch(
            f"/api/v1/delivery/assignments/{self.assignment.id}/status/", {"status": "picked_up"}
        )
        self.assertEqual(picked_up_response.status_code, 200, picked_up_response.data)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.PICKED_UP)

        delivered_response = self.client.patch(
            f"/api/v1/delivery/assignments/{self.assignment.id}/status/", {"status": "delivered"}
        )
        self.assertEqual(delivered_response.status_code, 200, delivered_response.data)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, MarketOrder.Status.DELIVERED)
        self.courier_profile.refresh_from_db()
        self.assertEqual(self.courier_profile.status, Courier.Status.AVAILABLE)

    def test_second_courier_cannot_accept_already_claimed_assignment(self):
        other_user = User.objects.create_user(phone="+998944444444")
        other_user.roles.create(role=Role.COURIER, tenant=None)
        Courier.objects.create(user=other_user)
        other_token = issue_token_for_role(other_user, "courier", None)

        self.client.post(f"/api/v1/delivery/assignments/{self.assignment.id}/accept/")

        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {other_token.access_token}")
        second_response = self.client.post(
            f"/api/v1/delivery/assignments/{self.assignment.id}/accept/"
        )
        self.assertEqual(second_response.status_code, 409)

    def test_non_courier_cannot_accept(self):
        customer_token = issue_token_for_role(self.order.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {customer_token.access_token}")

        response = self.client.post(f"/api/v1/delivery/assignments/{self.assignment.id}/accept/")
        self.assertEqual(response.status_code, 403)
