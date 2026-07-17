# Queue Backlog Runbook

## Overview
Covers message queue (RabbitMQ/Redis Streams) backlog buildup: order processing, notifications, payouts, chat messages.

## Alert Thresholds
- **Warning**: Queue depth > 1,000 for 5 min
- **Critical**: Queue depth > 10,000 or processing latency > 5 min
- **Page**: Queue not draining for 15 min, consumer count = 0

## Quick Diagnostics (0-2 minutes)

```bash
# Check Redis Streams (orders, notifications, chat)
kubectl exec -it redis-primary -- redis-cli XLEN orders_stream
kubectl exec -it redis-primary -- redis-cli XLEN notifications_stream
kubectl exec -it redis-primary -- redis-cli XLEN chat_stream

# Check consumer groups
kubectl exec -it redis-primary -- redis-cli XINFO GROUPS orders_stream
kubectl exec -it redis-primary -- redis-cli XINFO CONSUMERS orders_stream orders-group

# Check RabbitMQ (if used for payouts)
kubectl exec -it rabbitmq -- rabbitmqctl list_queues name messages consumers
```

## Common Issues & Resolutions

### 1. No Consumers Running
**Symptoms**: Queue depth growing, consumer count = 0
**Causes**: Pod crashed, deployment scaled to 0, consumer crashed on startup

**Resolution**:
```bash
# Check consumer pods
kubectl get pods -n gloss-prod -l app=gloss-backend -l role=consumer

# Check logs
kubectl logs -n gloss-prod -l role=consumer --tail=100

# Restart consumer deployment
kubectl rollout restart deployment/gloss-backend-consumer -n gloss-prod

# Scale up if needed
kubectl scale deployment gloss-backend-consumer --replicas=5 -n gloss-prod
```

### 2. Processing Too Slow
**Symptoms**: Queue depth growing, consumers running but lag increasing
**Causes**:
- Slow downstream API (payment gateway, external API)
- Database contention
- Inefficient processing logic
- Resource limits (CPU/memory)

**Resolution**:
```bash
# Check processing latency
kubectl exec -it redis-primary -- redis-cli XRANGE orders_stream - + COUNT 10 | head -20

# Check consumer processing time (logs)
kubectl logs -n gloss-prod -l role=consumer --tail=200 | grep -E "(processing|completed|failed).*(took"

# Scale consumers
kubectl scale deployment gloss-backend-consumer --replicas=10 -n gloss-prod

# Check resource usage
kubectl top pods -n gloss-prod -l role=consumer

# Increase resources if needed
kubectl patch deployment gloss-backend-consumer -n gloss-prod -p \
  '{"spec":{"template":{"spec":{"containers":[{"name":"consumer","resources":{"limits":{"memory":"2Gi","cpu":"2"},"requests":{"memory":"1Gi","cpu":"1"}}}]}}}}'
```

### 3. Dead Letter Queue Buildup
**Symptoms**: DLQ growing, repeated failures
**Causes**: 
- Permanent failures (invalid data, missing resources)
- Transient failures exhausted retries

**Resolution**:
```bash
# Check DLQ
kubectl exec -it redis-primary -- redis-cli XRANGE orders_dlq - + COUNT 20

# Inspect failed messages
# Analyze error patterns
# Fix root cause (data validation, missing resources)

# Replay after fix
kubectl exec -it redis-primary -- redis-cli XREAD COUNT 100 STREAMS orders_dlq 0 |
  # Parse and re-publish to main stream
```

### 4. Priority Inversion
**Symptoms**: High-priority messages stuck behind low-priority
**Resolution**:
```bash
# Use priority queues (Redis Streams with priority)
# Implement priority consumer that reads high-priority stream first

# Emergency: drain low-priority to process high-priority
# Temporarily pause low-priority consumers
kubectl scale deployment gloss-backend-consumer-low --replicas=0 -n gloss-prod
```

### 4. Message Size / Payload Issues
**Symptoms**: Large messages causing memory pressure, timeouts
**Resolution**:
```bash
# Check message sizes
kubectl exec -it redis-primary -- redis-cli XRANGE orders_stream - + COUNT 100 | \
  awk '{print length($0)}' | sort -n | tail -5

# If large: implement chunking or external storage (S3/MinIO) with reference
```

### 5. Backpressure / Flow Control
**Symptoms**: Producer blocked, API timeouts, OOM in producer
**Resolution**:
```bash
# Implement backpressure
# - Producer: async with bounded queue, reject when full (429)
# - Consumer: process in batches, acknowledge after processing
# - Circuit breaker for downstream failures

# Emergency: pause producers
kubectl scale deployment gloss-api --replicas=0 -n gloss-prod
# Process backlog
# Resume producers
kubectl scale deployment gloss-api --replicas=5 -n gloss-prod
```

## Scaling Actions

### Horizontal Scale Consumers
```bash
# Scale based on queue depth (HPA)
# Or manually:
kubectl scale deployment gloss-backend-consumer --replicas=15 -n gloss-prod

# Different consumer types
kubectl scale deployment gloss-consumer-orders --replicas=10 -n gloss-prod
kubectl scale deployment gloss-consumer-notifications --replicas=5 -n gloss-prod
kubectl scale deployment gloss-consumer-chat --replicas=3 -n gloss-prod
kubectl scale deployment gloss-consumer-payouts --replicas=2 -n gloss-prod
```

### Priority-based Scaling
```bash
# High priority queues get more consumers
kubectl scale deployment gloss-consumer-orders --replicas=10 -n gloss-prod
kubectl scale deployment gloss-consumer-payments --replicas=5 -n gloss-prod

# Low priority gets fewer
kubectl scale deployment gloss-consumer-notifications --replicas=2 -n gloss-prod
```

## Monitoring Queries

```promql
# Queue depth
redis_stream_length{stream="orders_stream"}
redis_stream_length{stream="notifications_stream"}

# Processing rate
rate(redis_stream_consumed_total[5m])

# Processing latency
histogram_quantile(0.95, rate(queue_processing_duration_seconds_bucket[5m]))

# Consumer count
redis_consumer_group_consumers{stream="orders_stream"}

# Dead letter queue depth
redis_stream_length{stream="orders_dlq"}

# Consumer lag
redis_stream_length - (redis_stream_consumer_read_position - redis_stream_consumer_delivered_position)
```

## Emergency Procedures

### Full Queue Drain (Emergency)
```bash
# 1. Pause producers
kubectl scale deployment gloss-api --replicas=0 -n gloss-prod

# 2. Scale consumers to max
kubectl scale deployment gloss-backend-consumer --replicas=20 -n gloss-prod

# 3. Monitor drain rate
watch -n 5 'kubectl exec -it redis-primary -- redis-cli XLEN orders_stream'

# 4. Resume producers when drained
kubectl scale deployment gloss-api --replicas=5 -n gloss-prod
```

### Selective Replay
```bash
# Replay specific time range
kubectl exec -it redis-primary -- redis-cli XRANGE orders_stream 1700000000000-0 1700000001000-0 COUNT 10000 |
  # Re-publish to processing stream
```

### Purge Dead Messages (Last Resort)
```bash
# Only if DLQ contains known-bad messages
kubectl exec -it redis-primary -- redis-cli DEL orders_dlq
# Or trim old entries
kubectl exec -it redis-primary -- redis-cli XTRIM orders_dlq MAXLEN 1000
```

## Monitoring Dashboard
- Queue depths (per stream)
- Processing rate (msg/sec)
- Latency p50/p95/p99
- Consumer count (per group)
- Dead letter queue depth
- Retry rate
- Error rate by type

## Escalation
1. On-call (0-5 min)
2. Platform Lead (5-15 min)
3. Engineering Manager (15+ min)

---

**Last Updated**: 2024-01-15  
**Owner**: Platform Team  
**Next Review**: 2024-04-15