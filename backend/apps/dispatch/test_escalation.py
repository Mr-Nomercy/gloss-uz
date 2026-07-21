from unittest.mock import patch

from django.contrib.gis.geos import Point
from django.test import TestCase
from django.utils import timezone

from apps.accounts.models import User
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.orders.models import Order
from apps.tenants.models import Tenant
from apps.workforce.models import Team

from .models import DispatchQueue
from .tasks import expire_offer_round


class EscalationTests(TestCase):
    """Celery runs synchronously in tests (CELERY_TASK_ALWAYS_EAGER, see
    config/settings/test.py) so these assert final state directly rather
    than waiting on a real 15s timer. Broadcasts hit the real local Redis
    channel layer — nothing is subscribed, so group_send() is a no-op
    beyond publishing, which is enough to prove it doesn't error.
    """

    def setUp(self):
        self.tenant = Tenant.objects.create(
            name="Firma A", phone="+998900000001", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        customer = User.objects.create_user(phone="+998911111111")
        category = ServiceCategory.objects.create(name="Uy tozalash")
        tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        address = Address.objects.create(
            user=customer, raw_address="X", city="Toshkent", lat="41.311081", lng="69.279737"
        )
        self.order = Order.objects.create(
            customer=customer,
            tariff=tariff,
            address=address,
            scheduled_time=timezone.now() + timezone.timedelta(days=1),
            total_price="50000.00",
        )

    @patch("apps.dispatch.tasks.expire_offer_round.apply_async")
    def test_no_response_escalates_to_a_new_team_not_yet_offered(self, mock_apply_async):
        # Without this patch, CELERY_TASK_ALWAYS_EAGER makes dispatch_order's
        # apply_async(countdown=15) for the *next* round fire immediately
        # too, collapsing the whole escalation chain into this one call —
        # in real deployment that countdown is a genuine 15s wait. Patching
        # it lets us assert state after exactly one round.
        first_team = Team.all_tenants.create(
            tenant=self.tenant,
            name="First",
            status=Team.Status.AVAILABLE,
            location=Point(69.28, 41.311, srid=4326),
        )
        second_team = Team.all_tenants.create(
            tenant=self.tenant,
            name="Second",
            status=Team.Status.AVAILABLE,
            location=Point(69.28, 41.312, srid=4326),
        )
        DispatchQueue.objects.create(order=self.order, team=first_team)

        expire_offer_round(self.order.id, [first_team.id], attempt=1)

        first_offer = DispatchQueue.objects.get(order=self.order, team=first_team)
        self.assertEqual(first_offer.status, DispatchQueue.Status.TIMEOUT)

        second_offer = DispatchQueue.objects.get(order=self.order, team=second_team)
        self.assertEqual(second_offer.status, DispatchQueue.Status.PENDING)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.SEARCHING)

    def test_cancels_order_after_max_attempts(self):
        team = Team.all_tenants.create(
            tenant=self.tenant,
            name="Only Team",
            status=Team.Status.AVAILABLE,
            location=Point(69.28, 41.311, srid=4326),
        )
        DispatchQueue.objects.create(order=self.order, team=team)

        expire_offer_round(self.order.id, [team.id], attempt=3)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.CANCELLED)

    def test_cancels_order_when_no_eligible_teams_remain(self):
        team = Team.all_tenants.create(
            tenant=self.tenant,
            name="Only Team",
            status=Team.Status.AVAILABLE,
            location=Point(69.28, 41.311, srid=4326),
        )
        DispatchQueue.objects.create(order=self.order, team=team)

        # attempt=1, but the only team is already in the excluded list —
        # nothing left to escalate to, so this should cancel immediately
        # rather than looping.
        expire_offer_round(self.order.id, [team.id], attempt=1)

        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.CANCELLED)

    def test_no_op_if_order_already_assigned(self):
        team = Team.all_tenants.create(
            tenant=self.tenant, name="Team", status=Team.Status.AVAILABLE
        )
        offer = DispatchQueue.objects.create(
            order=self.order, team=team, status=DispatchQueue.Status.ACCEPTED
        )
        self.order.status = Order.Status.ASSIGNED
        self.order.tenant = self.tenant
        self.order.save()

        expire_offer_round(self.order.id, [team.id], attempt=1)

        offer.refresh_from_db()
        self.assertEqual(offer.status, DispatchQueue.Status.ACCEPTED)
