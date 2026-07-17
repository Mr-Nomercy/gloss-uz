# Database Performance Runbook

## Overview
Covers PostgreSQL performance issues, connection pool exhaustion, slow queries, and lock contention.

## Alert Thresholds
- **Warning**: CPU > 70%, connections > 80% max, slow queries > 10/min
- **Critical**: CPU > 90%, connections > 95%, replication lag > 30s
- **Page**: Database unavailable, replication broken, disk > 90%

## Quick Diagnostics (0-3 minutes)

```bash
# Overall health
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT 
  (SELECT count(*) FROM pg_stat_activity WHERE state = 'active') as active,
  (SELECT count(*) FROM pg_stat_activity) as total,
  (SELECT setting::int FROM pg_settings WHERE name = 'max_connections') as max_connections,
  (SELECT round(100.0 * count(*) / (SELECT setting::int FROM pg_settings WHERE name = 'max_connections'), 2) 
   FROM pg_stat_activity) as usage_pct;
"

# Long-running queries
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT pid, now() - pg_stat_activity.query_start AS duration, 
       state, usename, query 
FROM pg_stat_activity 
WHERE state = 'active' 
  AND now() - pg_stat_activity.query_start > interval '30 seconds'
ORDER BY duration DESC LIMIT 10;
"

# Lock contention
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT blocked_locks.pid AS blocked_pid,
       blocked_activity.usename AS blocked_user,
       blocking_locks.pid AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query AS blocked_query,
       blocking_activity.query AS blocking_query
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks 
  ON blocking_locks.locktype = blocked_locks.locktype
  AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
  AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
  AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
  AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
  AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
  AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
  AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
  AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
  AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
  AND blocking_locks.pid != blocked_locks.pid
JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.GRANTED;
"

# Replication lag
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT client_addr, state, 
       pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS lag_bytes,
       pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) AS lag_size,
       now() - pg_stat_replication.sync_priority * interval '1 second' AS lag_time
FROM pg_stat_replication;
"
```

## Common Issues & Resolutions

### 1. Connection Pool Exhaustion
**Symptoms**: "connection pool exhausted", "too many connections"
**Resolution**:
```bash
# Check PgBouncer
kubectl exec -it pgbouncer -- pgbouncer -c "SHOW POOLS;"

# Increase pool size
# Edit pgbouncer config, reload
kubectl exec -it pgbouncer -- pgbouncer -c "RELOAD;"

# Check for connection leaks in app
# Search for unclosed connections in code
grep -r "pool\." packages/backend/src/ --include="*.ts" | grep -v "await.*release"
```

### 2. Slow Queries
**Symptoms**: High latency, high CPU, slow query log entries
**Resolution**:
```bash
# Identify slow queries
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT query, calls, total_exec_time, mean_exec_time, rows
FROM pg_stat_statements
ORDER BY mean_exec_time DESC LIMIT 20;
"

# Check for missing indexes
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT schemaname, tablename, seq_scan, seq_tup_read, idx_scan
FROM pg_stat_user_tables
WHERE seq_scan > 1000 AND idx_scan = 0
ORDER BY seq_tup_read DESC;
"

# Add missing indexes
# EXPLAIN ANALYZE slow query
# CREATE INDEX CONCURRENTLY ...
```

### 3. Lock Contention / Deadlocks
**Symptoms**: Deadlock errors, slow transactions, high lock wait
**Resolution**:
```bash
# Check for deadlocks
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT * FROM pg_stat_database WHERE deadlocks > 0;
"

# Check lock types
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT locktype, mode, count(*) 
FROM pg_locks 
WHERE NOT granted 
GROUP BY locktype, mode;
"

# Common fixes:
# 1. Keep transactions short
# 2. Access tables in consistent order
# 2. Add indexes to avoid full table scans
# 3. Use SELECT FOR UPDATE SKIP LOCKED for queues
```

### 4. Vacuum / Bloat Issues
**Symptoms**: Slow queries, table size growing, vacuum not running
**Resolution**:
```bash
# Check bloat
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT schemaname, tablename, n_dead_tup, n_live_tup,
       round(100.0 * n_dead_tup / (n_live_tup + n_dead_tup), 2) as dead_pct,
       last_vacuum, last_autovacuum
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY dead_pct DESC;
"

# Manual vacuum
kubectl exec -it pg-primary -- psql -U postgres -c "VACUUM ANALYZE problematic_table;"

# Check autovacuum settings
kubectl exec -it pg-primary -- psql -U postgres -c "SHOW autovacuum;"
```

### 5. Replication Lag
**Symptoms**: Replica lag > 30s, stale reads
**Resolution**:
```bash
# Check lag
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT application_name, state, 
       pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS lag_bytes,
       pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) AS lag_size
FROM pg_stat_replication;
"

# Fixes:
# 1. Reduce write batch size
# 2. Increase wal_sender_timeout
# 3. Check network between primary/replica
# 4. Scale replica resources
```

## Recovery Actions

### Emergency: Kill Long-Running Query
```bash
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE state = 'active' 
  AND now() - query_start > interval '5 minutes'
  AND query NOT ILIKE '%pg_stat_activity%';
"
```

### Emergency: Connection Pool Emergency
```bash
# Kill all idle connections
kubectl exec -it pg-primary -- psql -U postgres -c "
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE state = 'idle' 
  AND now() - state_change > interval '10 minutes';
"
```

## Monitoring Queries

```promql
# CPU usage
rate(container_cpu_usage_seconds_total{pod=~"pg-.*"}[5m])

# Memory usage
container_memory_usage_bytes{pod=~"pg-.*"} / container_spec_memory_limit_bytes{pod=~"pg-.*"}

# Connections
pg_stat_activity_count / pg_settings_max_connections

# Replication lag
pg_replication_lag_bytes

# Cache hit ratio
pg_stat_database_blks_hit / (pg_stat_database_blks_hit + pg_stat_database_blks_read)

# Slow queries rate
rate(pg_stat_statements_total_time_seconds_total[5m])
```

## Escalation
1. On-call (0-5 min)
2. Database Admin (5-15 min)
3. Engineering Manager (15+ min)

---

**Last Updated**: 2024-01-15  
**Owner**: Database Team  
**Next Review**: 2024-04-15