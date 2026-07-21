from django.db.models import Sum
from rest_framework import serializers

from apps.accounts.models import Role, User, UserRole
from apps.accounts.role_mapping import frontend_roles_for_user
from apps.core.serializers import StringPKModelSerializer
from apps.market.models import Category, Product
from apps.orders.models import Order
from apps.tenants.models import CommissionRule, Payout, Tenant, Wallet
from apps.workforce.models import WorkerProfile


class TenantCreateSerializer(serializers.Serializer):
    """Manual tenant onboarding (M5): platform_admin creates the record
    after the sales-led contract process happens outside the system —
    see docs/12-END-TO-END-ROADMAP.md's onboarding flow.

    Also provisions the firm's first tenant_admin, using the contact
    phone as their login identity — tenant_admin has no email+password
    login (that's platform_admin-only, see AdminLoginView), so phone+OTP
    via the same combined login every other role uses is how they get in.
    """

    company_name = serializers.CharField(max_length=255)
    phone = serializers.CharField(max_length=20)
    email = serializers.EmailField(required=False, allow_null=True)
    city = serializers.CharField(max_length=100)

    def validate_phone(self, value):
        if User.objects.filter(phone=value).exists():
            raise serializers.ValidationError("Bu telefon raqami allaqachon ro'yxatdan o'tgan")
        return value

    def create(self, validated_data):
        tenant = Tenant.objects.create(
            name=validated_data["company_name"],
            phone=validated_data["phone"],
            email=validated_data.get("email"),
            city=validated_data["city"],
            status=Tenant.Status.PENDING,
        )
        Wallet.objects.create(tenant=tenant)
        admin_user = User.objects.create_user(
            phone=validated_data["phone"], full_name=validated_data["company_name"]
        )
        UserRole.objects.create(user=admin_user, role=Role.TENANT_ADMIN, tenant=tenant)
        return tenant


class TenantSerializer(StringPKModelSerializer):
    companyName = serializers.CharField(source="name")
    isActive = serializers.SerializerMethodField()
    totalOrders = serializers.SerializerMethodField()
    totalWorkers = serializers.SerializerMethodField()

    class Meta:
        model = Tenant
        fields = [
            "id",
            "companyName",
            "phone",
            "email",
            "logo_url",
            "rating",
            "totalOrders",
            "totalWorkers",
            "commission_rate",
            "isActive",
            "is_verified",
            "created_at",
        ]

    def get_isActive(self, tenant):
        return tenant.status == Tenant.Status.ACTIVE

    def get_totalOrders(self, tenant):
        return Order.objects.filter(tenant=tenant).count()

    def get_totalWorkers(self, tenant):
        return WorkerProfile.all_tenants.filter(tenant=tenant).count()


class TenantWorkerSerializer(StringPKModelSerializer):
    fullName = serializers.CharField(source="user.full_name")
    phone = serializers.CharField(source="user.phone")
    isActive = serializers.SerializerMethodField()

    class Meta:
        model = WorkerProfile
        fields = ["id", "fullName", "phone", "isActive"]

    def get_isActive(self, worker_profile):
        return worker_profile.status == WorkerProfile.Status.ACTIVE


class TenantOrderSerializer(StringPKModelSerializer):
    orderNumber = serializers.SerializerMethodField()
    amount = serializers.DecimalField(source="total_price", max_digits=12, decimal_places=2)

    class Meta:
        model = Order
        fields = ["id", "orderNumber", "status", "amount", "created_at"]

    def get_orderNumber(self, order):
        return f"ORD-{order.id:06d}"


class TenantDetailSerializer(serializers.Serializer):
    tenant = TenantSerializer()
    workers = TenantWorkerSerializer(many=True)
    orders = TenantOrderSerializer(many=True)
    balance = serializers.DecimalField(max_digits=14, decimal_places=2)
    total_earnings = serializers.DecimalField(max_digits=14, decimal_places=2)


class CommissionRuleSerializer(StringPKModelSerializer):
    serviceTypeId = serializers.SerializerMethodField()
    serviceTypeName = serializers.CharField(source="service_type")
    rate = serializers.DecimalField(source="percentage", max_digits=5, decimal_places=2)

    class Meta:
        model = CommissionRule
        fields = ["id", "serviceTypeId", "serviceTypeName", "rate", "min_order_amount"]

    def get_serviceTypeId(self, rule):
        return str(rule.id)


class ProductSerializer(StringPKModelSerializer):
    salePrice = serializers.DecimalField(
        source="sale_price", max_digits=12, decimal_places=2, allow_null=True, required=False
    )
    stockQty = serializers.IntegerField(source="stock_qty")
    categoryId = serializers.SerializerMethodField()
    categoryName = serializers.SerializerMethodField()
    sellerId = serializers.SerializerMethodField()
    sellerName = serializers.SerializerMethodField()
    imageUrls = serializers.SerializerMethodField()
    isActive = serializers.BooleanField(source="is_active")

    class Meta:
        model = Product
        fields = [
            "id",
            "name",
            "description",
            "price",
            "salePrice",
            "stockQty",
            "categoryId",
            "categoryName",
            "sellerId",
            "sellerName",
            "imageUrls",
            "rating",
            "isActive",
            "created_at",
        ]

    def get_categoryId(self, product):
        return str(product.category_id) if product.category_id else None

    def get_categoryName(self, product):
        return product.category.name if product.category_id else None

    def get_sellerId(self, product):
        # Product Owner is Gloss itself — no third-party seller concept.
        return None

    def get_sellerName(self, product):
        return None

    def get_imageUrls(self, product):
        return [image.url for image in product.images.all()]


class CategorySerializer(StringPKModelSerializer):
    parentId = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ["id", "name", "parentId"]

    def get_parentId(self, category):
        return str(category.parent_id) if category.parent_id else None


class AdminOrderSerializer(StringPKModelSerializer):
    orderNumber = serializers.SerializerMethodField()
    clientName = serializers.CharField(source="customer.full_name")
    clientPhone = serializers.CharField(source="customer.phone")
    providerName = serializers.SerializerMethodField()
    courierName = serializers.SerializerMethodField()
    type = serializers.SerializerMethodField()
    paymentStatus = serializers.SerializerMethodField()
    subtotal = serializers.DecimalField(source="tariff.base_price", max_digits=12, decimal_places=2)
    discount = serializers.SerializerMethodField()
    deliveryFee = serializers.SerializerMethodField()
    platformFee = serializers.SerializerMethodField()
    total = serializers.DecimalField(source="total_price", max_digits=12, decimal_places=2)
    addressLine = serializers.CharField(source="address.raw_address")
    scheduledAt = serializers.DateTimeField(source="scheduled_time")

    class Meta:
        model = Order
        fields = [
            "id",
            "orderNumber",
            "clientName",
            "clientPhone",
            "providerName",
            "courierName",
            "type",
            "status",
            "paymentStatus",
            "subtotal",
            "discount",
            "deliveryFee",
            "platformFee",
            "total",
            "addressLine",
            "scheduledAt",
            "created_at",
        ]

    def get_orderNumber(self, order):
        return f"ORD-{order.id:06d}"

    def get_providerName(self, order):
        return order.tenant.name if order.tenant_id else None

    def get_courierName(self, order):
        # No delivery/courier model yet (M6) — cleaning orders only for now.
        return None

    def get_type(self, order):
        return "service"

    def get_paymentStatus(self, order):
        return "paid" if order.status == Order.Status.COMPLETED else "pending"

    def get_discount(self, order):
        return 0

    def get_deliveryFee(self, order):
        return 0

    def get_platformFee(self, order):
        return order.commission_amount or 0


class PayoutSerializer(StringPKModelSerializer):
    providerId = serializers.SerializerMethodField()
    providerName = serializers.CharField(source="tenant.name")
    cardNumber = serializers.CharField(source="card_number")
    adminNote = serializers.CharField(source="admin_note", allow_null=True, required=False)
    processedAt = serializers.DateTimeField(source="processed_at", allow_null=True, required=False)

    class Meta:
        model = Payout
        fields = [
            "id",
            "providerId",
            "providerName",
            "amount",
            "cardNumber",
            "status",
            "adminNote",
            "processedAt",
            "created_at",
        ]

    def get_providerId(self, payout):
        return str(payout.tenant_id)


class AppUserSerializer(StringPKModelSerializer):
    fullName = serializers.CharField(source="full_name")
    avatarUrl = serializers.SerializerMethodField()
    roles = serializers.SerializerMethodField()
    isBlocked = serializers.BooleanField(source="is_blocked")
    totalOrders = serializers.SerializerMethodField()
    totalSpent = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            "id",
            "fullName",
            "phone",
            "email",
            "avatarUrl",
            "roles",
            "isBlocked",
            "totalOrders",
            "totalSpent",
            "created_at",
        ]

    def get_avatarUrl(self, user):
        return None

    def get_roles(self, user):
        return frontend_roles_for_user(user)

    def get_totalOrders(self, user):
        return Order.objects.filter(customer=user).count()

    def get_totalSpent(self, user):
        total = Order.objects.filter(customer=user).aggregate(total=Sum("total_price"))["total"]
        return total or 0
