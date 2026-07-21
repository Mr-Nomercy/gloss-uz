from decimal import Decimal

from django.utils import timezone
from rest_framework.test import APITestCase

from apps.accounts.models import Role, User
from apps.accounts.tokens import issue_token_for_role
from apps.addresses.models import Address
from apps.catalog.models import ServiceCategory, Tariff
from apps.market.models import Category, Product
from apps.orders.models import Order
from apps.tenants.models import CommissionRule, Payout, Tenant, Wallet
from apps.workforce.models import Team, WorkerProfile


class AdminApiTests(APITestCase):
    def setUp(self):
        self.admin = User.objects.create_user(phone="+998900000001", email="admin@gloss.uz")
        self.admin.set_password("admin123")
        self.admin.save()
        self.admin.roles.create(role=Role.PLATFORM_ADMIN, tenant=None)

        token = issue_token_for_role(self.admin, "platform_admin", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        self.tenant = Tenant.objects.create(
            name="Firma A", phone="+998900000002", city="Toshkent", status=Tenant.Status.ACTIVE
        )
        Wallet.objects.create(tenant=self.tenant, balance="100000.00")

        self.customer = User.objects.create_user(phone="+998911111111", full_name="Mijoz Bir")
        self.customer.roles.create(role=Role.CUSTOMER, tenant=None)

        category = ServiceCategory.objects.create(name="Uy tozalash")
        self.tariff = Tariff.objects.create(
            service_category=category, name="Standart", base_price="50000.00", duration_min=180
        )
        address = Address.objects.create(
            user=self.customer, raw_address="Amir Temur 1", city="Toshkent", lat="41.3", lng="69.2"
        )
        self.order = Order.objects.create(
            customer=self.customer,
            tenant=self.tenant,
            tariff=self.tariff,
            address=address,
            status=Order.Status.COMPLETED,
            scheduled_time=timezone.now(),
            total_price="50000.00",
            commission_amount="7500.00",
            net_amount="42500.00",
        )

    def test_admin_login_with_email_password(self):
        self.client.credentials()  # unauthenticated for this call
        response = self.client.post(
            "/api/v1/admin/auth/login", {"email": "admin@gloss.uz", "password": "admin123"}
        )
        self.assertEqual(response.status_code, 200, response.data)
        # response.data is the pre-render Python dict (DRF test-client
        # convenience) — camelCase is a render-time transform, so the
        # actual wire contract has to be checked via response.json().
        body = response.json()
        self.assertIn("accessToken", body)
        self.assertEqual(body["user"]["email"], "admin@gloss.uz")
        self.assertIn("super_admin", body["user"]["roles"])

    def test_admin_login_rejects_wrong_password(self):
        self.client.credentials()
        response = self.client.post(
            "/api/v1/admin/auth/login", {"email": "admin@gloss.uz", "password": "wrong"}
        )
        self.assertEqual(response.status_code, 401)

    def test_non_admin_role_cannot_reach_admin_endpoints(self):
        token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        response = self.client.get("/api/v1/admin/dashboard")

        self.assertEqual(response.status_code, 403)

    def test_dashboard_returns_camel_case_stats(self):
        response = self.client.get("/api/v1/admin/dashboard")

        self.assertEqual(response.status_code, 200, response.data)
        self.assertIn("totalRevenue", response.data)
        self.assertIn("weeklyRevenue", response.data)
        self.assertEqual(response.data["totalRevenue"], 50000.0)

    def test_tenants_list_and_detail(self):
        list_response = self.client.get("/api/v1/admin/tenants")
        self.assertEqual(list_response.status_code, 200, list_response.data)
        self.assertIsInstance(list_response.data, list)
        tenant_json = list_response.data[0]
        self.assertEqual(tenant_json["companyName"], "Firma A")
        self.assertIsInstance(tenant_json["id"], str)
        self.assertTrue(tenant_json["isActive"])

        detail_response = self.client.get(f"/api/v1/admin/tenants/{self.tenant.id}")
        self.assertEqual(detail_response.status_code, 200, detail_response.data)
        self.assertEqual(detail_response.data["balance"], "100000.00")

    def test_toggle_tenant_active(self):
        response = self.client.patch(f"/api/v1/admin/tenants/{self.tenant.id}", {"isActive": False})
        self.assertEqual(response.status_code, 200, response.data)
        self.tenant.refresh_from_db()
        self.assertEqual(self.tenant.status, Tenant.Status.SUSPENDED)

    def test_update_tenant_commission(self):
        response = self.client.patch(
            f"/api/v1/admin/tenants/{self.tenant.id}/commission", {"commissionRate": 0.22}
        )
        self.assertEqual(response.status_code, 200, response.data)
        self.tenant.refresh_from_db()
        self.assertEqual(float(self.tenant.commission_rate), 0.22)

    def test_commissions_list_and_bulk_save(self):
        rule = CommissionRule.objects.create(
            service_type="Uy tozalash", percentage="10.00", tenant=None
        )

        list_response = self.client.get("/api/v1/admin/commissions")
        self.assertEqual(list_response.status_code, 200)
        self.assertEqual(list_response.data[0]["serviceTypeName"], "Uy tozalash")

        save_response = self.client.put(
            "/api/v1/admin/commissions",
            {
                "commissions": [
                    {"serviceTypeId": str(rule.id), "rate": 12.5, "minOrderAmount": 40000}
                ]
            },
        )
        self.assertEqual(save_response.status_code, 200, save_response.data)
        rule.refresh_from_db()
        self.assertEqual(float(rule.percentage), 12.5)

    def test_market_products_and_categories(self):
        category = Category.objects.create(name="Kir yuvish vositalari")
        Product.objects.create(name="Sovun", price="15000.00", category=category, stock_qty=10)

        products_response = self.client.get("/api/v1/admin/market/products")
        self.assertEqual(products_response.status_code, 200)
        self.assertEqual(products_response.data[0]["name"], "Sovun")
        self.assertIsNone(products_response.data[0]["sellerId"])

        categories_response = self.client.get("/api/v1/admin/market/categories")
        self.assertEqual(categories_response.status_code, 200)
        self.assertEqual(categories_response.data[0]["name"], "Kir yuvish vositalari")

    def test_toggle_and_delete_product(self):
        product = Product.objects.create(name="Cho'tka", price="8000.00")

        toggle_response = self.client.patch(
            f"/api/v1/admin/market/products/{product.id}", {"isActive": False}
        )
        self.assertEqual(toggle_response.status_code, 200)
        product.refresh_from_db()
        self.assertFalse(product.is_active)

        delete_response = self.client.delete(f"/api/v1/admin/market/products/{product.id}")
        self.assertEqual(delete_response.status_code, 204)
        self.assertFalse(Product.objects.filter(id=product.id).exists())

    def test_orders_list_and_detail(self):
        list_response = self.client.get("/api/v1/admin/orders")
        self.assertEqual(list_response.status_code, 200)
        order_json = list_response.data[0]
        self.assertEqual(order_json["clientName"], "Mijoz Bir")
        self.assertEqual(order_json["providerName"], "Firma A")
        self.assertEqual(order_json["paymentStatus"], "paid")

        detail_response = self.client.get(f"/api/v1/admin/orders/{self.order.id}")
        self.assertEqual(detail_response.status_code, 200)
        self.assertEqual(detail_response.data["total"], "50000.00")

    def test_payouts_list_approve_reject(self):
        payout = Payout.objects.create(
            tenant=self.tenant, amount="50000.00", card_number="8600123456789012"
        )

        list_response = self.client.get("/api/v1/admin/payouts")
        self.assertEqual(list_response.status_code, 200)
        self.assertEqual(list_response.data[0]["providerName"], "Firma A")

        approve_response = self.client.patch(
            f"/api/v1/admin/payouts/{payout.id}/approve", {"adminNote": "OK"}
        )
        self.assertEqual(approve_response.status_code, 200)
        payout.refresh_from_db()
        self.assertEqual(payout.status, Payout.Status.APPROVED)

        other_payout = Payout.objects.create(
            tenant=self.tenant, amount="10000.00", card_number="8600123456789099"
        )
        reject_response = self.client.patch(
            f"/api/v1/admin/payouts/{other_payout.id}/reject", {"reason": "shubhali"}
        )
        self.assertEqual(reject_response.status_code, 200)
        other_payout.refresh_from_db()
        self.assertEqual(other_payout.status, Payout.Status.REJECTED)

    def test_users_list_detail_and_block(self):
        list_response = self.client.get("/api/v1/admin/users")
        self.assertEqual(list_response.status_code, 200)
        user_json = next(u for u in list_response.data if u["phone"] == self.customer.phone)
        self.assertIn("client", user_json["roles"])
        self.assertEqual(user_json["totalOrders"], 1)

        detail_response = self.client.get(f"/api/v1/admin/users/{self.customer.id}")
        self.assertEqual(detail_response.status_code, 200)
        self.assertEqual(len(detail_response.data["recentOrders"]), 1)

        block_response = self.client.patch(
            f"/api/v1/admin/users/{self.customer.id}", {"isBlocked": True}
        )
        self.assertEqual(block_response.status_code, 200)
        self.customer.refresh_from_db()
        self.assertTrue(self.customer.is_blocked)

    def test_worker_role_appears_correctly_for_tenant_worker(self):
        team = Team.all_tenants.create(
            tenant=self.tenant, name="Team A", status=Team.Status.AVAILABLE
        )
        worker_user = User.objects.create_user(phone="+998933333333", full_name="Ishchi Bir")
        worker_user.roles.create(role=Role.TENANT_WORKER, tenant=self.tenant)
        WorkerProfile.all_tenants.create(tenant=self.tenant, user=worker_user, team=team)

        response = self.client.get(f"/api/v1/admin/tenants/{self.tenant.id}")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data["workers"][0]["fullName"], "Ishchi Bir")

    def test_blocking_a_user_actually_revokes_api_access(self):
        # Found during audit: is_blocked was set by this exact endpoint but
        # nothing anywhere checked it — blocking a user had zero real effect.
        self.client.patch(f"/api/v1/admin/users/{self.customer.id}", {"isBlocked": True})

        blocked_token = issue_token_for_role(self.customer, "customer", None)
        blocked_client = self.client_class()
        blocked_client.credentials(HTTP_AUTHORIZATION=f"Bearer {blocked_token.access_token}")

        response = blocked_client.get("/api/v1/orders/")

        self.assertEqual(response.status_code, 401)

    def test_commission_rate_out_of_bounds_is_rejected(self):
        response = self.client.patch(
            f"/api/v1/admin/tenants/{self.tenant.id}/commission", {"commissionRate": 5}
        )

        self.assertEqual(response.status_code, 400)
        self.tenant.refresh_from_db()
        self.assertNotEqual(float(self.tenant.commission_rate), 5.0)

    def test_commissions_bulk_save_rejects_out_of_bounds_rate(self):
        rule = CommissionRule.objects.create(
            service_type="Uy tozalash", percentage="10.00", tenant=None
        )

        response = self.client.put(
            "/api/v1/admin/commissions",
            {"commissions": [{"serviceTypeId": str(rule.id), "rate": 150}]},
        )

        self.assertEqual(response.status_code, 400)
        rule.refresh_from_db()
        self.assertEqual(float(rule.percentage), 10.0)

    def test_commissions_bulk_save_rejects_missing_fields(self):
        response = self.client.put(
            "/api/v1/admin/commissions",
            {"commissions": [{"serviceTypeId": "999"}]},
        )

        self.assertEqual(response.status_code, 400)

    def test_payout_approve_debits_wallet_and_guards_against_double_approval(self):
        payout = Payout.objects.create(
            tenant=self.tenant, amount="30000.00", card_number="8600000000000000"
        )

        response = self.client.patch(
            f"/api/v1/admin/payouts/{payout.id}/approve", {"adminNote": "ok"}
        )
        self.assertEqual(response.status_code, 200, response.data)

        wallet = Wallet.objects.get(tenant=self.tenant)
        self.assertEqual(wallet.balance, Decimal("70000.00"))

        second_response = self.client.patch(
            f"/api/v1/admin/payouts/{payout.id}/approve", {"adminNote": "again"}
        )
        self.assertEqual(second_response.status_code, 409)
        wallet.refresh_from_db()
        self.assertEqual(wallet.balance, Decimal("70000.00"))

    def test_payout_approve_rejected_when_wallet_balance_insufficient(self):
        payout = Payout.objects.create(
            tenant=self.tenant, amount="999999.00", card_number="8600000000000000"
        )

        response = self.client.patch(f"/api/v1/admin/payouts/{payout.id}/approve", {})

        self.assertEqual(response.status_code, 400)
        payout.refresh_from_db()
        self.assertEqual(payout.status, Payout.Status.PENDING)

    def test_payout_reject_guards_against_double_action(self):
        payout = Payout.objects.create(
            tenant=self.tenant,
            amount="10000.00",
            card_number="8600000000000000",
            status=Payout.Status.REJECTED,
        )

        response = self.client.patch(
            f"/api/v1/admin/payouts/{payout.id}/reject", {"reason": "again"}
        )

        self.assertEqual(response.status_code, 409)

    def test_platform_admin_can_create_tenant(self):
        response = self.client.post(
            "/api/v1/admin/tenants",
            {"companyName": "Yangi Firma", "phone": "+998900000099", "city": "Buxoro"},
        )

        self.assertEqual(response.status_code, 201, response.data)
        tenant = Tenant.objects.get(name="Yangi Firma")
        self.assertEqual(tenant.status, Tenant.Status.PENDING)
        self.assertTrue(Wallet.objects.filter(tenant=tenant).exists())

    def test_non_admin_cannot_create_tenant(self):
        token = issue_token_for_role(self.customer, "customer", None)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token.access_token}")

        response = self.client.post(
            "/api/v1/admin/tenants",
            {"companyName": "X", "phone": "+998900000000", "city": "X"},
        )

        self.assertEqual(response.status_code, 403)
