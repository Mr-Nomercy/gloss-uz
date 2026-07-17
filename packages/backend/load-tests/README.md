# Gloss Backend Load Tests (k6)

## Prerequisites

1. Install k6: https://k6.io/docs/getting-started/installation/
2. Backend server running at `BASE_URL` (default: http://localhost:3000/api/v1)
3. Valid JWT token in `AUTH_TOKEN` environment variable
4. For WebSocket tests: WebSocket server running at `WS_URL` (default: ws://localhost:3000/api/v1)

## Running Load Tests

### Orders API Load Test (10k RPS)

```bash
# Basic run
k6 run --env BASE_URL=http://localhost:3000/api/v1 --env AUTH_TOKEN=<your-jwt-token> load-tests/orders-api-load-test.js

# With k6 Cloud
k6 run --env K6_PROJECT_ID=<project-id> --env BASE_URL=https://api.gloss.uz/api/v1 --env AUTH_TOKEN=<token> load-tests/orders-api-load-test.js

# With custom stages
k6 run --env BASE_URL=http://localhost:3000/api/v1 --env AUTH_TOKEN=<token> --stage 100:30s --stage 1000:2m --stage 5000:5m --stage 10000:10m load-tests/orders-api-load-test.js
```

### WebSocket Load Test (5k Connections)

```bash
# Basic run
k6 run --env WS_URL=ws://localhost:3000/api/v1 --env AUTH_TOKEN=<your-jwt-token> --env ORDER_ID=<order-id> load-tests/websocket-load-test.js

# With k6 Cloud
k6 run --env K6_PROJECT_ID=<project-id> --env WS_URL=wss://api.gloss.uz/api/v1 --env AUTH_TOKEN=<token> --env ORDER_ID=<order-id> load-tests/websocket-load-test.js
```

## Test Scenarios

### Orders API (orders-api-load-test.js)

**Target**: 10,000 RPS sustained for 10 minutes

**Stages**:
1. Warm-up: 100 → 1,000 RPS over 2 minutes
2. Ramp-up: 1,000 → 5,000 RPS over 3 minutes
3. Peak: 5,000 → 10,000 RPS over 5 minutes
4. Sustained: 10,000 RPS for 10 minutes
5. Ramp-down: 10,000 → 5,000 RPS over 3 minutes
6. Cool-down: 5,000 → 1,000 RPS over 2 minutes
7. Final: 1,000 → 0 RPS over 1 minute

**Thresholds**:
- p95 latency < 500ms
- p99 latency < 1000ms
- Error rate < 1%
- Check success rate > 99%
- Sustained RPS ≥ 10,000

**Endpoints tested**:
- `POST /orders` - Create order (primary load)
- `GET /orders` - List orders (secondary)

### WebSocket (websocket-load-test.js)

**Target**: 5,000 concurrent WebSocket connections sustained for 10 minutes

**Stages**:
1. Warm-up: 100 → 1,000 connections over 2 minutes
2. Ramp-up: 1,000 → 3,000 connections over 3 minutes
3. Peak: 3,000 → 5,000 connections over 5 minutes
4. Sustained: 5,000 connections for 10 minutes
5. Ramp-down: 5,000 → 3,000 connections over 3 minutes
6. Cool-down: 3,000 → 1,000 connections over 2 minutes
7. Final: 1,000 → 0 connections over 1 minute

**Thresholds**:
- Connection time p95 < 2000ms
- Session duration p95 > 300s (5 minutes)
- Message receive rate > 100/sec
- Ping latency p95 < 100ms
- Check success rate > 99%
- Connection error rate < 1%

**Behavior per connection**:
- Sends ping every 10 seconds
- Sends order status message every 5 seconds
- Listens for pong and incoming messages
- Maintains connection for up to 10 minutes

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `BASE_URL` | REST API base URL | `http://localhost:3000/api/v1` |
| `WS_URL` | WebSocket URL | `ws://localhost:3000/api/v1` |
| `AUTH_TOKEN` | JWT access token | Required |
| `ORDER_ID` | Order ID for WebSocket test | `test-order-id` |
| `K6_PROJECT_ID` | k6 Cloud project ID | Optional |

## CI/CD Integration

Add to `.github/workflows/load-test.yml`:

```yaml
name: Load Tests
on:
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday 2AM
  workflow_dispatch:

jobs:
  load-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run k6 Orders API Test
        uses: grafana/k6-action@v0.2
        with:
          filename: packages/backend/load-tests/orders-api-load-test.js
          env: |
            BASE_URL=${{ secrets.STAGING_API_URL }}
            AUTH_TOKEN=${{ secrets.STAGING_AUTH_TOKEN }}
            K6_PROJECT_ID=${{ secrets.K6_PROJECT_ID }}
      
      - name: Run k6 WebSocket Test
        uses: grafana/k6-action@v0.2
        with:
          filename: packages/backend/load-tests/websocket-load-test.js
          env: |
            WS_URL=${{ secrets.STAGING_WS_URL }}
            AUTH_TOKEN=${{ secrets.STAGING_AUTH_TOKEN }}
            ORDER_ID=${{ secrets.TEST_ORDER_ID }}
            K6_PROJECT_ID=${{ secrets.K6_PROJECT_ID }}
```

## Analyzing Results

1. **k6 Cloud**: View detailed graphs at https://app.k6.io
2. **Local JSON**: Check `summary.json` and `ws-summary.json` output files
3. **Key Metrics to Monitor**:
   - HTTP request duration (p50, p95, p99)
   - Request rate (RPS)
   - Error rate
   - WebSocket connection establishment time
   - Message latency
   - Connection dropout rate

## Troubleshooting

### High Latency
- Check database connection pool size
- Verify Redis connection for WebSocket adapter
- Check CPU/memory on backend pods
- Review query performance with `EXPLAIN ANALYZE`

### Connection Failures
- Increase filedes
- Check WebSocket server max connections
- Verify load balancer WebSocket support
- Check proxy timeouts (nginx: `proxy_read_timeout`)

### Low RPS
- Increase `maxVUs` in test options
- Check rate limiting middleware
- Verify database connection pool
- Check Node.js event loop lag

## Generating Test Data

Before running load tests, ensure test data exists:

```bash
# Create test users, products, addresses
npm run seed:load-test

# Or manually create via API
curl -X POST $BASE_URL/auth/register -d '{"phone": "+998901234567", "password": "test123"}'
curl -X POST $BASE_URL/addresses -H "Authorization: Bearer $TOKEN" -d '{"lat": 41.2995, "lng": 69.2401, "addressLine": "Test Address"}'
curl -X POST $BASE_URL/products -H "Authorization: Bearer $SELLER_TOKEN" -d '{"name": "Test Product", "basePrice": 10000, "categoryId": "cat-id", "sellerId": "seller-id"}'
```