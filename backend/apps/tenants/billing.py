from decimal import Decimal

from .models import CommissionRule, Transaction, Wallet


def calculate_commission(order):
    """Tenant-specific override takes priority over the platform-wide
    default for the same service type; if neither CommissionRule exists,
    fall back to the tenant's own flat commission_rate.
    """
    service_type = order.tariff.service_category.name
    rule = CommissionRule.objects.filter(service_type=service_type, tenant=order.tenant).first()
    if rule is None:
        rule = CommissionRule.objects.filter(service_type=service_type, tenant__isnull=True).first()

    if rule is not None:
        rate = rule.percentage / Decimal(100)
    else:
        rate = order.tenant.commission_rate

    commission = (order.total_price * rate).quantize(Decimal("0.01"))
    net = order.total_price - commission
    return commission, net


def bill_completed_order(order):
    """Called once, at the moment an order transitions to completed —
    the caller is expected to hold this inside the same transaction as
    that status change (see apps.orders.views.WorkerOrderStatusView).
    """
    commission, net = calculate_commission(order)
    order.commission_amount = commission
    order.net_amount = net
    order.save(update_fields=["commission_amount", "net_amount"])

    wallet, _ = Wallet.objects.select_for_update().get_or_create(tenant=order.tenant)
    wallet.balance += net
    wallet.save(update_fields=["balance"])

    Transaction.objects.create(
        wallet=wallet, order=order, type=Transaction.Type.COMMISSION_CREDIT, amount=net
    )
