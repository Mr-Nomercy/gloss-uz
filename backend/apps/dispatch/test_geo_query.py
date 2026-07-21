from django.contrib.gis.geos import Point
from django.test import TestCase
from django.utils import timezone

from apps.accounts.models import User
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.orders.models import Order
from apps.tenants.models import Tenant
from apps.workforce.models import Team

from .services import find_eligible_teams


class FindEligibleTeamsTests(TestCase):
    """Real PostGIS distance query — this cannot be verified on sqlite,
    which is why M3 needed actual Postgres+PostGIS to test at all.
    """

    def setUp(self):
        self.tenant_a = Tenant.objects.create(
            name="Firma A", phone="+998900000001", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        self.tenant_b = Tenant.objects.create(
            name="Firma B", phone="+998900000002", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        self.suspended_tenant = Tenant.objects.create(
            name="Firma C", phone="+998900000003", city="Toshkent", status=Tenant.Status.SUSPENDED
        )

        customer = User.objects.create_user(phone="+998911111111")
        category = ServiceCategory.objects.create(name="Uy tozalash")
        tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        # Amir Temur maydoni, Toshkent
        address = Address.objects.create(
            user=customer, raw_address="Markaz", city="Toshkent", lat="41.311081", lng="69.279737"
        )
        self.order = Order.objects.create(
            customer=customer,
            tariff=tariff,
            address=address,
            scheduled_time=timezone.now() + timezone.timedelta(days=1),
            total_price="50000.00",
        )

        # ~1km away — eligible
        self.near_team = Team.all_tenants.create(
            tenant=self.tenant_a,
            name="Near Team",
            status=Team.Status.AVAILABLE,
            location=Point(69.290, 41.315, srid=4326),
        )
        # ~250km away (Samarqand-ish longitude offset) — out of default 10km radius
        self.far_team = Team.all_tenants.create(
            tenant=self.tenant_b,
            name="Far Team",
            status=Team.Status.AVAILABLE,
            location=Point(66.9749, 39.6270, srid=4326),
        )
        # near, but busy — not eligible
        self.busy_team = Team.all_tenants.create(
            tenant=self.tenant_a,
            name="Busy Team",
            status=Team.Status.BUSY,
            location=Point(69.291, 41.316, srid=4326),
        )
        # near, but belongs to a suspended tenant — not eligible
        self.suspended_team = Team.all_tenants.create(
            tenant=self.suspended_tenant,
            name="Suspended Tenant Team",
            status=Team.Status.AVAILABLE,
            location=Point(69.292, 41.317, srid=4326),
        )
        # near, but no location set yet — not eligible
        self.no_location_team = Team.all_tenants.create(
            tenant=self.tenant_b, name="No Location Team", status=Team.Status.AVAILABLE
        )

    def test_finds_nearby_available_team_across_tenants(self):
        results = list(find_eligible_teams(self.order))
        self.assertIn(self.near_team, results)

    def test_excludes_teams_outside_radius(self):
        results = list(find_eligible_teams(self.order))
        self.assertNotIn(self.far_team, results)

    def test_excludes_busy_teams(self):
        results = list(find_eligible_teams(self.order))
        self.assertNotIn(self.busy_team, results)

    def test_excludes_teams_from_suspended_tenants(self):
        results = list(find_eligible_teams(self.order))
        self.assertNotIn(self.suspended_team, results)

    def test_excludes_teams_without_a_location(self):
        results = list(find_eligible_teams(self.order))
        self.assertNotIn(self.no_location_team, results)

    def test_orders_by_distance_nearest_first(self):
        closer = Team.all_tenants.create(
            tenant=self.tenant_b,
            name="Closer Team",
            status=Team.Status.AVAILABLE,
            location=Point(69.2805, 41.3115, srid=4326),
        )
        results = list(find_eligible_teams(self.order))
        self.assertEqual(results[0], closer)

    def test_respects_exclude_team_ids(self):
        results = list(find_eligible_teams(self.order, exclude_team_ids=[self.near_team.id]))
        self.assertNotIn(self.near_team, results)
