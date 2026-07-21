from rest_framework import mixins, status, viewsets
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.delivery.services import dispatch_market_order
from apps.payments.models import Transaction
from apps.payments.providers import build_pay_url

from .models import Cart, Category, MarketOrder, Product
from .serializers import (
    AddCartItemSerializer,
    CartSerializer,
    CategorySerializer,
    CheckoutSerializer,
    MarketOrderSerializer,
    ProductSerializer,
)
from .services import restore_stock


class ProductListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        products = (
            Product.objects.filter(is_active=True)
            .select_related("category")
            .prefetch_related("images")
            .order_by("-created_at")
        )
        category_id = request.query_params.get("category")
        if category_id:
            products = products.filter(category_id=category_id)
        return Response(ProductSerializer(products, many=True).data)


class CategoryListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        return Response(CategorySerializer(Category.objects.all(), many=True).data)


class CartView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cart, _ = Cart.objects.get_or_create(customer=request.user)
        return Response(CartSerializer(cart).data)


class CartItemView(APIView):
    """{product_id, qty} — qty 0 removes the item, otherwise sets it
    (not increments — the client always knows the desired quantity)."""

    permission_classes = [IsAuthenticated]

    def post(self, request):
        cart, _ = Cart.objects.get_or_create(customer=request.user)
        serializer = AddCartItemSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        product = serializer.validated_data["product"]
        qty = serializer.validated_data["qty"]

        if qty == 0:
            cart.items.filter(product=product).delete()
        else:
            cart.items.update_or_create(product=product, defaults={"qty": qty})

        return Response(CartSerializer(cart).data)


class CheckoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        cart, _ = Cart.objects.get_or_create(customer=request.user)
        serializer = CheckoutSerializer(
            data=request.data, context={"request": request, "cart": cart}
        )
        serializer.is_valid(raise_exception=True)
        order = serializer.save()

        if order.payment_method == MarketOrder.PaymentMethod.CASH:
            order.status = MarketOrder.Status.CONFIRMED
            order.save(update_fields=["status"])
            dispatch_market_order(order)
            return Response(MarketOrderSerializer(order).data, status=status.HTTP_201_CREATED)

        provider_map = {
            MarketOrder.PaymentMethod.PAYME: Transaction.Provider.PAYME,
            MarketOrder.PaymentMethod.CLICK: Transaction.Provider.CLICK,
        }
        txn = Transaction.objects.create(
            market_order=order,
            provider=provider_map[order.payment_method],
            amount=order.total_price,
        )
        return Response(
            {**MarketOrderSerializer(order).data, "pay_url": build_pay_url(txn)},
            status=status.HTTP_201_CREATED,
        )


class MarketOrderViewSet(mixins.ListModelMixin, mixins.RetrieveModelMixin, viewsets.GenericViewSet):
    serializer_class = MarketOrderSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return MarketOrder.objects.filter(customer=self.request.user).prefetch_related("items")

    @action(detail=True, methods=["post"])
    def cancel(self, request, pk=None):
        order = self.get_object()
        if order.status not in (MarketOrder.Status.PENDING, MarketOrder.Status.CONFIRMED):
            return Response(
                {"error": "cannot_cancel_in_current_status"}, status=status.HTTP_400_BAD_REQUEST
            )
        order.status = MarketOrder.Status.CANCELLED
        order.save(update_fields=["status"])
        restore_stock(order)
        return Response(MarketOrderSerializer(order).data)
