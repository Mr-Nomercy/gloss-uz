import base64

from django.conf import settings


def build_pay_url(transaction):
    """Checkout redirect URL for the transaction's provider. Only needs
    the public merchant/service id (safe with empty settings in dev —
    the URL just won't resolve to anything live); the secret key is only
    used to verify inbound webhooks, never here.
    """
    if transaction.provider == transaction.Provider.PAYME:
        return _payme_pay_url(transaction)
    if transaction.provider == transaction.Provider.CLICK:
        return _click_pay_url(transaction)
    raise ValueError(f"Unknown payment provider: {transaction.provider}")


def _payme_pay_url(transaction):
    # https://developer.help.paycom.uz/initsializatsiya-platezhey/
    amount_tiyin = int(transaction.amount * 100)
    params = (
        f"m={settings.PAYME_MERCHANT_ID};ac.order_id={transaction.market_order_id};a={amount_tiyin}"
    )
    encoded = base64.b64encode(params.encode()).decode()
    return f"https://checkout.paycom.uz/{encoded}"


def _click_pay_url(transaction):
    # https://docs.click.uz/en/click-api-request/
    return (
        "https://my.click.uz/services/pay"
        f"?service_id={settings.CLICK_SERVICE_ID}"
        f"&merchant_id={settings.CLICK_MERCHANT_ID}"
        f"&amount={transaction.amount}"
        f"&transaction_param={transaction.market_order_id}"
    )
