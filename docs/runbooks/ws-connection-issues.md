# WebSocket Connection Issues Runbook

## Overview
Handles WebSocket connection issues affecting chat, order tracking, and real-time notifications.

## Alert Thresholds
- **Warning**: WS connection count < 80% expected for 5 min
- **Critical**: WS count < 50% or > 500 errors/min
- **Page**: All WS down or > 1000 errors/min

## Quick Diagnostics (0-2 minutes)

```bash
# Check WebSocket gateway pods
kubectl get pods -n gloss-prod -l app=gloss-backend,role=ws-gateway

# Check active connections
kubectl exec -it backend-pod -- curl -s localhost:3000/api/v1/ws/stats

# Check error rate
kubectl logs -n gloss-prod -l app=gloss-backend --since=5m | grep -c "WS.*error\|WebSocket.*error"

# Check Redis pub/sub
kubectl exec -it redis-primary -- redis-cli PUBSUB CHANNELS
kubectl exec -it redis-primary -- redis-cli PUBSUB NUMSUB "orders:*" "chat:*" "notifications:*"
```

## Common Issues & Solutions

### 1. All Connections Dropped Simultaneously
**Symptoms**: All WS connections closed at once, reconnection storms
**Causes**:
- Backend deployment/restart
- Redis restart/failover
- Network partition
- Load balancer config change

**Resolution**:
```bash
# Check recent deployments
kubectl rollout history deployment/gloss-backend-blue -n gloss-prod

# Check Redis
kubectl get pods -n gloss-prod -l app=redis

# Monitor reconnection rate
watch -n 5 'kubectl exec -it backend-pod -- curl -s localhost:3000/api/v1/ws/stats | jq .connections'
```

### 2. High Connection Failure Rate
**Symptoms**: Many `ECONNREFUSED`, `ETIMEDOUT`, `400 Bad Request` on WS upgrade
**Causes**:
- Backend pods overloaded (CPU/memory)
- Nginx rate limiting WS upgrades
- Redis connection pool exhausted
- TLS/SSL certificate issues

**Resolution**:
```bash
# Check backend resources
kubectl top pods -n gloss-prod -l app=gloss-backend

# Check nginx config
kubectl exec -it nginx-pod -- nginx -T | grep -A 20 "location /ws"

# Check Redis connections
kubectl exec -it redis-primary -- redis-cli INFO clients
```

### 3. Specific Feature Failures
| Feature | Channel Pattern | Common Issue |
|---------|----------------|--------------|
| Order Tracking | `orders:{orderId}` | Tracking gateway down, Redis pub/sub fail |
| Chat | `chat:{chatId}` | Chat gateway down, message queue full |
| Notifications | `notifications:{userId}` | Notification service down, FCM failures |
| Courier Location | `courier:{courierId}:location` | Location gateway down, GPS issues |

**Resolution per Feature**:
```bash
# Order Tracking
kubectl logs -n gloss-prod -l app=gloss-backend,role=tracking --since=10m | grep -i error

# Chat
kubectl logs -n gloss-prod -l app=gloss-backend,role=chat --since=10m | grep -i error

# Check Redis channels
kubectl exec -it redis-primary -- redis-cli PUBSUB NUMSUB "orders:*" "chat:*" "notifications:*"
```

### 4. Client Reconnection Issues
**Symptoms**: Clients can't reconnect, exponential backoff not working
**Causes**:
- JWT token expired during disconnect
- Server rejecting reconnection auth
- Client app bug in reconnection logic

**Resolution**:
```bash
# Check auth on WS handshake
kubectl logs -n gloss-prod -l app=gloss-backend --since=10m | grep "WS auth"

# Verify JWT secret matches
kubectl get secret gloss-backend -n gloss-prod -o jsonpath='{.data.JWT_ACCESS_SECRET}' | base64 -d
```

## Nginx WebSocket Configuration Check

```bash
# Verify nginx config
kubectl exec -it nginx-pod -- nginx -T | grep -A 30 "location /ws"

# Expected config:
# location /ws/ {
#     proxy_pass http://backend;
#     proxy_http_version 1.1;
#     proxy_set_header Upgrade $http_upgrade;
#     proxy_set_header Connection "upgrade";
#     proxy_read_timeout 86400;
#     proxy_send_timeout 86400;
# }
```

## Recovery Actions

### Graceful Degradation
1. **Chat**: Fallback to polling (if implemented)
2. **Tracking**: Show last known location, show "connecting..."
3. **Notifications**: Fall back to FCM push only

### Full Recovery
```bash
# 1. Restart WS gateway pods (if isolated issue)
kubectl rollout restart deployment/gloss-backend -n gloss-prod

# 2. Monitor reconnection rate
watch -n 5 'kubectl exec -it backend-pod -- curl -s localhost:3000/api/v1/ws/stats | jq .connections'

# 3. Check Redis pub/sub
kubectl exec -it redis-primary -- redis-cli PUBSUB NUMSUB "orders:*" "chat:*" "notifications:*"
```

## Monitoring Queries

```promql
# Active connections
redis_stream_length{stream=~"orders_.*|chat_.*|notifications_.*"}

# Connection errors rate
rate(websocket_errors_total[5m])

# Reconnection rate
rate(websocket_reconnections_total[5m])

# Active connections per pod
websocket_connections_active{pod=~".*"}

# Message throughput
rate(websocket_messages_total[5m])
```

## Escalation
1. On-call (0-5 min)
2. Platform Lead (5-15 min)
3. Engineering Manager (15+ min)

---

**Last Updated**: 2024-01-15  
**Owner**: Platform Team  
**Next Review**: 2024-04-15