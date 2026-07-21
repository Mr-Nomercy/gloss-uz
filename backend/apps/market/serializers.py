from django.db import transaction
from rest_framework import serializers

from apps.addresses.models import Address

from .models import Cart, CartItem, Category, MarketOrder, MarketOrderItem, Product


class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name", "parent"]


class ProductSerializer(serializers.ModelSerializer):
    images = serializers.SlugRelatedField(slug_field="url", many=True, read_only=True)

    class Meta:
        model = Product
        fields = [
            "id",
            "name",
            "description",
            "price",
            "sale_price",
            "stock_qty",
            "category",
            "rating",
            "images",
        ]
        read_only_fields = fields


class CartItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)

    class Meta:
        model = CartItem
        fields = ["id", "product", "qty"]
        read_only_fields = fields


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = Cart
        fields = ["id", "items", "total_price"]
        read_only_fields = fields

    def get_total_price(self, cart):
        return str(sum((item.product.price * item.qty for item in cart.items.all()), start=0))


class AddCartItemSerializer(serializers.Serializer):
    product_id = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.filter(is_active=True), source="product"
    )
    qty = serializers.IntegerField(min_value=0)

    def validate(self, attrs):
        if attrs["qty"] > attrs["product"].stock_qty:
            raise serializers.ValidationError({"qty": "Omborda yetarli mahsulot yo'q"})
        return attrs


class MarketOrderItemSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)

    class Meta:
        model = MarketOrderItem
        fields = ["id", "product", "product_name", "qty", "unit_price"]
        read_only_fields = fields


class MarketOrderSerializer(serializers.ModelSerializer):
    items = MarketOrderItemSerializer(many=True, read_only=True)

    class Meta:
        model = MarketOrder
        fields = [
            "id",
            "address",
            "status",
            "payment_method",
            "total_price",
            "items",
            "created_at",
        ]
        read_only_fields = fields


class CheckoutSerializer(serializers.Serializer):
    address_id = serializers.PrimaryKeyRelatedField(
        queryset=Address.objects.all(), source="address"
    )
    payment_method = serializers.ChoiceField(choices=MarketOrder.PaymentMethod.choices)

    def validate_address_id(self, address):
        request = self.context["request"]
        if address.user_id != request.user.id:
            raise serializers.ValidationError("Not your address.")
        return address

    def create(self, validated_data):
        request = self.context["request"]
        cart = self.context["cart"]
        items = list(cart.items.select_related("product"))
        if not items:
            raise serializers.ValidationError({"cart": "Savat bo'sh"})

        with transaction.atomic():
            for item in items:
                # select_for_update: two concurrent checkouts against the
                # same product's last few units must not both succeed.
                product = Product.objects.select_for_update().get(id=item.product_id)
                if not product.is_active or item.qty > product.stock_qty:
                    raise serializers.ValidationError(
                        {"cart": f"'{product.name}' omborda yetarli emas"}
                    )

            total_price = sum(item.product.price * item.qty for item in items)
            order = MarketOrder.objects.create(
                customer=request.user,
                address=validated_data["address"],
                payment_method=validated_data["payment_method"],
                total_price=total_price,
            )
            for item in items:
                MarketOrderItem.objects.create(
                    market_order=order,
                    product=item.product,
                    qty=item.qty,
                    unit_price=item.product.price,
                )
                item.product.stock_qty -= item.qty
                item.product.save(update_fields=["stock_qty"])

            cart.items.all().delete()

        return order
