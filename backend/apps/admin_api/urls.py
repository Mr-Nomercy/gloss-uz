from django.urls import path

from .auth_views import AdminLoginView, AdminRefreshView
from .views import (
    AdminOrderDetailView,
    AdminOrdersView,
    AdminUserDetailView,
    AdminUsersView,
    CommissionsView,
    DashboardView,
    MarketCategoriesView,
    MarketProductDetailView,
    MarketProductsView,
    PayoutApproveView,
    PayoutRejectView,
    PayoutsView,
    TenantViewSet,
)

tenant_list = TenantViewSet.as_view({"get": "list"})
tenant_detail = TenantViewSet.as_view({"get": "retrieve", "patch": "partial_update"})
tenant_commission = TenantViewSet.as_view({"patch": "commission"})

urlpatterns = [
    path("auth/login", AdminLoginView.as_view(), name="admin-auth-login"),
    path("auth/refresh", AdminRefreshView.as_view(), name="admin-auth-refresh"),
    path("dashboard", DashboardView.as_view(), name="admin-dashboard"),
    path("tenants", tenant_list, name="admin-tenants"),
    path("tenants/<int:pk>", tenant_detail, name="admin-tenant-detail"),
    path("tenants/<int:pk>/commission", tenant_commission, name="admin-tenant-commission"),
    path("commissions", CommissionsView.as_view(), name="admin-commissions"),
    path("market/products", MarketProductsView.as_view(), name="admin-market-products"),
    path(
        "market/products/<int:pk>",
        MarketProductDetailView.as_view(),
        name="admin-market-product-detail",
    ),
    path("market/categories", MarketCategoriesView.as_view(), name="admin-market-categories"),
    path("orders", AdminOrdersView.as_view(), name="admin-orders"),
    path("orders/<int:pk>", AdminOrderDetailView.as_view(), name="admin-order-detail"),
    path("payouts", PayoutsView.as_view(), name="admin-payouts"),
    path("payouts/<int:pk>/approve", PayoutApproveView.as_view(), name="admin-payout-approve"),
    path("payouts/<int:pk>/reject", PayoutRejectView.as_view(), name="admin-payout-reject"),
    path("users", AdminUsersView.as_view(), name="admin-users"),
    path("users/<int:pk>", AdminUserDetailView.as_view(), name="admin-user-detail"),
]
