# Payment Failures Runbook

## Overview
Covers payment processing failures for Click, Payme, and Cash payments.

## Alert Thresholds
- **Warning**: Payment failure rate > 2% for 5 min
- **Critical**: Payment failure rate > 10% or specific gateway down
- **Page**: All payments failing, or webhook failures > 50%

## Quick Diagnostics (0-2 minutes)

```bash
# Check payment gateway health
curl -s https://api.click.uz/health
curl -s https://api.payme.uz/health

# Check webhook endpoints
curl -s -X POST https://api.gloss.uz/api/v1/payments/click/callback \
  -H "Content-Type: application/json" \
  -d '{"test":true}'

# Check recent payment failures
kubectl logs -n gloss-prod -l app=gloss-backend --tail=100 | grep -i "payment\|click\|payme" | grep -i "error\|fail" | head -20
```

## Common Issues & Resolutions

### 1. Click Payment Gateway
**Common Issues**:
- **Invalid signature**: Check `CLICK_SECRET_KEY` matches merchant panel
- **Service ID mismatch**: Verify `CLICK_SERVICE_ID` matches merchant panel
- **Merchant ID mismatch**: Verify `CLICK_MERCHANT_ID`
- **Callback URL unreachable**: Check firewall, DNS, SSL
- **Amount mismatch**: Order amount * 100 must match Click amount

**Resolution**:
```bash
# Verify config
kubectl exec -it backend-pod -- env | grep CLICK

# Test signature validation
# Check Click merchant panel for transaction status

# If signature issues: rotate secret key in Click panel and update K8s secret
kubectl create secret generic click-config --from-literal=CLICK_SECRET_KEY=new_secret --dry-run=client -o yaml | kubectl apply -f -
```

### 2. Payme Payment Gateway
**Common Issues**:
- **Invalid auth**: `PAYME_SECRET_KEY` mismatch
- **Merchant ID mismatch**: `PAYME_MERCHANT_ID` 
- **Callback authentication failed**: Check Basic auth header
- **Transaction not found**: Order ID mismatch

**Resolution**:
```bash
# Verify config
kubectl exec -it backend-pod -- env | grep PAYME

# Test Payme auth
curl -X POST https://api.gloss.uz/api/v1/payments/payme/callback \
  -H "Authorization: Basic $(echo -n 'paycom_id:secret' | base64)" \
  -H "Content-Type: application/json" \
  -d '{"method":"CheckPerformTransaction","params":{"account":{"order_id":"test"},"amount":100000}}'

# Check Payme merchant panel for transaction status
```

### 3. Cash Payment Issues
**Common Issues**:
- **Not marked paid on delivery**: Courier didn't confirm
- **Double payment**: Customer paid cash + online
- **Amount mismatch**: Courier collected wrong amount

**Resolution**:
```bash
# Check cash payment status
kubectl exec -it backend-pod -- curl -X POST http://localhost:3000/api/v1/payments/cash/confirm \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"orderId":"ORDER_ID","courierId":"COURIER_ID"}'

# Manual mark as paid (admin)
kubectl exec -it backend-pod -- curl -X POST http://localhost:3000/api/v1/admin/payments/ORDER_ID/cash-confirm
```

### 4. Webhook Failures
**Common Issues**:
- **Timeout**: Gateway timeout waiting for response
- **Invalid response**: Non-200 response from webhook
- **Duplicate processing**: Idempotency key missing
- **Signature verification failed**

**Resolution**:
```bash
# Check webhook logs
kubectl logs -n gloss-prod -l app=gloss-backend --tail=200 | grep -i "webhook\|callback" | grep -i "click\|payme"

# Check idempotency
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT id, order_id, provider, status, created_at 
FROM payments 
WHERE provider IN ('click','payme') 
ORDER BY created_at DESC LIMIT 20;"

# Manual webhook replay (if idempotent)
curl -X POST https://api.gloss.uz/api/v1/payments/click/callback \
  -H "Content-Type: application/json" \
  -d '{"click_trans_id":"...","click_paydoc_id":"...","service_id":"...","merchant_trans_id":"...","amount":"...","action":1,"sign_time":"...","sign_string":"..."}'
```

### 5. Refund Failures
**Common Issues**:
- **Insufficient funds**: Merchant balance too low
- **Transaction not refundable**: Already refunded, expired
- **Gateway error**: Click/Payme API error

**Resolution**:
```bash
# Check refund status
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT id, payment_id, amount, status, reason, created_at 
FROM refunds 
ORDER BY created_at DESC LIMIT 20;"

# Manual refund via gateway dashboard
# Check Click/Payme merchant panel for refund status

# Retry failed refund
kubectl exec -it backend-pod -- curl -X POST http://localhost:3000/api/v1/payments/REFUND_ID/retry
```

## Escalation Contacts

| Gateway | Support | SLA |
|---------|---------|-----|
| Click | support@click.uz | 1 hour |
| Payme | support@payme.uz | 1 hour |

## Monitoring Queries

```promql
# Payment success rate
sum(rate(payments_completed_total[5m])) / sum(rate(payments_initiated_total[5m]))

# Payment failure rate by provider
sum by (provider) (rate(payments_failed_total[5m])) / sum by (provider) (rate(payments_total[5m]))

# Webhook latency
histogram_quantile(0.95, rate(payment_webhook_duration_seconds_bucket[5m]))

# Pending payments count
payments_pending{provider="click"} + payments_pending{provider="payme"}
```

## Escalation
1. On-call (0-5 min)
2. Payment Team Lead (5-15 min)
3. Engineering Manager (15+ min)

---

**Last Updated**: 2024-01-15  
**Owner**: Payments Team  
**Next Review**: 2024-04-15