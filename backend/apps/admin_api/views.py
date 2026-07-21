from datetime import timedelta
from decimal import Decimal, InvalidOperation

from django.db import transaction
from django.db.models import Sum
from django.utils import timezone
from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.accounts.models import User
from apps.core.permissions import IsPlatformAdmin
from apps.market.models import Category, Product
from apps.orders.models import Order
from apps.tenants.models import CommissionRule, Payout, Tenant, Wallet
from apps.workforce.models import Team, WorkerProfile

from .serializers import (
    AdminOrderSerializer,
    AppUserSerializer,
    CategorySerializer,
    CommissionRuleSerializer,
    PayoutSerializer,
    ProductSerializer,
    TenantDetailSerializer,
    TenantSerializer,
)


class DashboardView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        now = timezone.now()
        today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)

        total_revenue = (
            Order.objects.filter(status=Order.Status.COMPLETED).aggregate(total=Sum("total_price"))[
                "total"
            ]
            or 0
        )
        total_commission = (
            Order.objects.filter(status=Order.Status.COMPLETED).aggregate(
                total=Sum("commission_amount")
            )["total"]
            or 0
        )

        weekly_revenue = []
        weekly_orders = []
        for i in range(6, -1, -1):
            day = (now - timedelta(days=i)).date()
            day_orders = Order.objects.filter(created_at__date=day)
            weekly_revenue.append(
                {
                    "label": day.strftime("%a"),
                    "value": float(day_orders.aggregate(t=Sum("total_price"))["t"] or 0),
                }
            )
            weekly_orders.append({"label": day.strftime("%a"), "value": day_orders.count()})

        recent = Order.objects.select_related("customer", "tariff").order_by("-created_at")[:10]
        recent_orders = [
            {
                "id": str(order.id),
                "orderNumber": f"ORD-{order.id:06d}",
                "clientName": order.customer.full_name,
                "amount": float(order.total_price),
                "status": order.status,
                "type": "service",
                "createdAt": order.created_at.isoformat(),
            }
            for order in recent
        ]

        return Response(
            {
                "totalRevenue": float(total_revenue),
                "todayOrders": Order.objects.filter(created_at__gte=today_start).count(),
                "activeProviders": Team.all_tenants.filter(status=Team.Status.AVAILABLE).count(),
                "totalUsers": User.objects.count(),
                "totalCommission": float(total_commission),
                "weeklyRevenue": weekly_revenue,
                "weeklyOrders": weekly_orders,
                "recentOrders": recent_orders,
            }
        )


class TenantViewSet(viewsets.ModelViewSet):
    permission_classes = [IsPlatformAdmin]
    serializer_class = TenantSerializer
    queryset = Tenant.objects.all().order_by("-created_at")
    pagination_class = None
    http_method_names = ["get", "patch"]

    def retrieve(self, request, *args, **kwargs):
        tenant = self.get_object()
        workers = WorkerProfile.all_tenants.filter(tenant=tenant).select_related("user")
        orders = Order.objects.filter(tenant=tenant).order_by("-created_at")[:50]
        wallet = getattr(tenant, "wallet", None)
        balance = wallet.balance if wallet else 0
        total_earnings = (
            Order.objects.filter(tenant=tenant, status=Order.Status.COMPLETED).aggregate(
                total=Sum("net_amount")
            )["total"]
            or 0
        )

        data = TenantDetailSerializer(
            {
                "tenant": tenant,
                "workers": workers,
                "orders": orders,
                "balance": balance,
                "total_earnings": total_earnings,
            }
        ).data
        return Response(data)

    def partial_update(self, request, *args, **kwargs):
        # The camel-case parser underscoreizes incoming JSON keys before
        # they reach request.data — "isActive" arrives as "is_active".
        tenant = self.get_object()
        if "is_active" in request.data:
            tenant.status = (
                Tenant.Status.ACTIVE if request.data["is_active"] else Tenant.Status.SUSPENDED
            )
            tenant.save(update_fields=["status"])
        return Response(TenantSerializer(tenant).data)

    @action(detail=True, methods=["patch"])
    def commission(self, request, pk=None):
        tenant = self.get_object()
        rate = request.data.get("commission_rate")
        if rate is None:
            return Response(
                {"message": "commissionRate required"}, status=status.HTTP_400_BAD_REQUEST
            )
        try:
            rate_decimal = Decimal(str(rate))
        except InvalidOperation:
            return Response(
                {"message": "commissionRate is not a number"}, status=status.HTTP_400_BAD_REQUEST
            )
        if not (0 <= rate_decimal <= 1):
            return Response(
                {"message": "commissionRate must be between 0 and 1"},
                status=status.HTTP_400_BAD_REQUEST,
            )
        tenant.commission_rate = rate_decimal
        tenant.save(update_fields=["commission_rate"])
        return Response(TenantSerializer(tenant).data)


class CommissionsView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        rules = CommissionRule.objects.filter(tenant__isnull=True)
        return Response(CommissionRuleSerializer(rules, many=True).data)

    def put(self, request):
        for item in request.data.get("commissions", []):
            rule_id = item.get("service_type_id")
            rate = item.get("rate")
            if rule_id is None or rate is None:
                return Response(
                    {"message": "each commission needs serviceTypeId and rate"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            try:
                rate_decimal = Decimal(str(rate))
            except InvalidOperation:
                return Response(
                    {"message": f"rate for {rule_id} is not a number"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            if not (0 <= rate_decimal <= 100):
                return Response(
                    {"message": f"rate for {rule_id} must be between 0 and 100"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            rule = CommissionRule.objects.filter(id=rule_id, tenant__isnull=True).first()
            if rule is None:
                return Response(
                    {"message": f"unknown commission rule: {rule_id}"},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            # .update() would bypass field validators entirely — going
            # through the instance + save() is what actually enforces them.
            rule.percentage = rate_decimal
            rule.min_order_amount = item.get("min_order_amount", rule.min_order_amount)
            rule.save(update_fields=["percentage", "min_order_amount"])

        rules = CommissionRule.objects.filter(tenant__isnull=True)
        return Response(CommissionRuleSerializer(rules, many=True).data)


class MarketProductsView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        products = (
            Product.objects.select_related("category")
            .prefetch_related("images")
            .order_by("-created_at")
        )
        return Response(ProductSerializer(products, many=True).data)


class MarketProductDetailView(APIView):
    permission_classes = [IsPlatformAdmin]

    def patch(self, request, pk):
        product = Product.objects.filter(id=pk).first()
        if product is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        if "is_active" in request.data:
            product.is_active = request.data["is_active"]
            product.save(update_fields=["is_active"])
        return Response(ProductSerializer(product).data)

    def delete(self, request, pk):
        Product.objects.filter(id=pk).delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class MarketCategoriesView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        categories = Category.objects.all()
        return Response(CategorySerializer(categories, many=True).data)


class AdminOrdersView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        orders = Order.objects.select_related("customer", "tenant", "tariff", "address").order_by(
            "-created_at"
        )
        return Response(AdminOrderSerializer(orders, many=True).data)


class AdminOrderDetailView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request, pk):
        order = (
            Order.objects.select_related("customer", "tenant", "tariff", "address")
            .filter(id=pk)
            .first()
        )
        if order is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        return Response(AdminOrderSerializer(order).data)


class PayoutsView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        payouts = Payout.objects.select_related("tenant").order_by("-created_at")
        return Response(PayoutSerializer(payouts, many=True).data)


class PayoutApproveView(APIView):
    permission_classes = [IsPlatformAdmin]

    def patch(self, request, pk):
        with transaction.atomic():
            payout = Payout.objects.select_for_update().filter(id=pk).first()
            if payout is None:
                return Response(status=status.HTTP_404_NOT_FOUND)
            if payout.status != Payout.Status.PENDING:
                return Response(
                    {"message": f"payout is already {payout.status}, not pending"},
                    status=status.HTTP_409_CONFLICT,
                )

            wallet = Wallet.objects.select_for_update().filter(tenant_id=payout.tenant_id).first()
            if wallet is None or wallet.balance < payout.amount:
                return Response(
                    {"message": "insufficient tenant wallet balance for this payout"},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            wallet.balance -= payout.amount
            wallet.save(update_fields=["balance"])

            payout.status = Payout.Status.APPROVED
            payout.admin_note = request.data.get("admin_note")
            payout.processed_at = timezone.now()
            payout.save(update_fields=["status", "admin_note", "processed_at"])

        return Response(PayoutSerializer(payout).data)


class PayoutRejectView(APIView):
    permission_classes = [IsPlatformAdmin]

    def patch(self, request, pk):
        payout = Payout.objects.filter(id=pk).first()
        if payout is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        if payout.status != Payout.Status.PENDING:
            return Response(
                {"message": f"payout is already {payout.status}, not pending"},
                status=status.HTTP_409_CONFLICT,
            )
        payout.status = Payout.Status.REJECTED
        payout.admin_note = request.data.get("reason")
        payout.processed_at = timezone.now()
        payout.save(update_fields=["status", "admin_note", "processed_at"])
        return Response(PayoutSerializer(payout).data)


class AdminUsersView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request):
        users = User.objects.all().order_by("-created_at")
        return Response(AppUserSerializer(users, many=True).data)


class AdminUserDetailView(APIView):
    permission_classes = [IsPlatformAdmin]

    def get(self, request, pk):
        user = User.objects.filter(id=pk).first()
        if user is None:
            return Response(status=status.HTTP_404_NOT_FOUND)

        orders = Order.objects.filter(customer=user).order_by("-created_at")[:20]
        recent_orders = [
            {
                "id": str(order.id),
                "orderNumber": f"ORD-{order.id:06d}",
                "status": order.status,
                "amount": float(order.total_price),
                "createdAt": order.created_at.isoformat(),
            }
            for order in orders
        ]
        addresses = [
            {"id": str(a.id), "rawAddress": a.raw_address, "city": a.city}
            for a in user.addresses.all()
        ]

        return Response(
            {
                "user": AppUserSerializer(user).data,
                "recentOrders": recent_orders,
                "addresses": addresses,
            }
        )

    def patch(self, request, pk):
        user = User.objects.filter(id=pk).first()
        if user is None:
            return Response(status=status.HTTP_404_NOT_FOUND)
        if "is_blocked" in request.data:
            user.is_blocked = request.data["is_blocked"]
            user.save(update_fields=["is_blocked"])
        return Response(AppUserSerializer(user).data)
