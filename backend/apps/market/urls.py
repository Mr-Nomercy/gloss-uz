from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import (
    CartItemView,
    CartView,
    CategoryListView,
    CheckoutView,
    MarketOrderViewSet,
    ProductListView,
)

router = DefaultRouter()
router.register("market-orders", MarketOrderViewSet, basename="market-order")

urlpatterns = router.urls + [
    path("products/", ProductListView.as_view(), name="market-products"),
    path("categories/", CategoryListView.as_view(), name="market-categories"),
    path("cart/", CartView.as_view(), name="market-cart"),
    path("cart/items/", CartItemView.as_view(), name="market-cart-items"),
    path("cart/checkout/", CheckoutView.as_view(), name="market-cart-checkout"),
]
