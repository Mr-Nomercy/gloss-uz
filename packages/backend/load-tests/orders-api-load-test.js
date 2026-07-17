import http from 'k6/http';
import { check, sleep, group } from 'k6';
import { Rate, Trend, Counter } from 'k6/metrics';
import { SharedArray } from 'k6/data';

export const options = {
  scenarios: {
    orders_api_load: {
      executor: 'ramping-arrival-rate',
      startRate: 100,
      timeUnit: '1s',
      preAllocatedVUs: 500,
      maxVUs: 2000,
      stages: [
        { target: 1000, duration: '2m' },
        { target: 5000, duration: '3m' },
        { target: 10000, duration: '5m' },
        { target: 10000, duration: '10m' },
        { target: 5000, duration: '3m' },
        { target: 1000, duration: '2m' },
        { target: 0, duration: '1m' },
      ],
    },
  },
  thresholds: {
    http_req_duration: ['p(95)<500', 'p(99)<1000'],
    http_req_failed: ['rate<0.01'],
    http_reqs: ['rate>10000'],
    checks: ['rate>0.99'],
    'checks{scenario:orders_api_load}': ['rate>0.99'],
  },
  ext: {
    loadimpact: {
      projectID: __ENV.K6_PROJECT_ID,
      name: 'Orders API Load Test - 10k RPS',
    },
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:3000/api/v1';
const AUTH_TOKEN = __ENV.AUTH_TOKEN || '';

const authHeaders = {
  Authorization: `Bearer ${AUTH_TOKEN}`,
  'Content-Type': 'application/json',
};

const createOrderPayload = () => ({
  type: 'product',
  addressId: 'test-address-id',
  items: [
    {
      productId: 'test-product-id',
      variantId: 'test-variant-id',
      quantity: 1,
      sellerId: 'test-seller-id',
    },
  ],
  promoCode: '',
  notes: 'Load test order',
});

const ordersCreated = new Counter('orders_created');
const ordersFailed = new Counter('orders_failed');
const orderCreationDuration = new Trend('order_creation_duration');
const orderCreationSuccessRate = new Rate('order_creation_success_rate');

export function setup() {
  const res = http.get(`${BASE_URL}/health`, { headers: authHeaders });
  if (res.status !== 200) {
    throw new Error(`Health check failed: ${res.status}`);
  }
  console.log('Health check passed');
  return { baseUrl: BASE_URL, token: AUTH_TOKEN };
}

export default function (data) {
  const payload = JSON.stringify(createOrderPayload());

  group('Create Order', () => {
    const startTime = new Date();
    const res = http.post(`${data.baseUrl}/orders`, payload, {
      headers: authHeaders,
      tags: { name: 'CreateOrder' },
    });

    const duration = new Date() - startTime;
    orderCreationDuration.add(duration);

    const success = check(res, {
      'status is 201': (r) => r.status === 201,
      'has order id': (r) => r.json('id') !== undefined,
      'has order number': (r) => r.json('orderNumber') !== undefined,
      'response time < 500ms': () => duration < 500,
    });

    orderCreationSuccessRate.add(success);
    if (success) {
      ordersCreated.add(1);
    } else {
      ordersFailed.add(1);
      console.error(`Order creation failed: ${res.status} - ${res.body}`);
    }
  });

  group('Get Orders List', () => {
    const res = http.get(`${data.baseUrl}/orders?page=1&limit=20`, {
      headers: authHeaders,
      tags: { name: 'GetOrdersList' },
    });

    check(res, {
      'status is 200': (r) => r.status === 200,
      'has items array': (r) => Array.isArray(r.json('items')),
    });
  });

  sleep(Math.random() * 0.1);
}

export function handleSummary(data) {
  const { metrics } = data;
  const summary = {
    timestamp: new Date().toISOString(),
    test: 'orders-api-load-test',
    targetRPS: 10000,
    duration: metrics.http_req_duration?.values?.max || 0,
    totalRequests: metrics.http_reqs?.values?.count || 0,
    failedRequests: metrics.http_req_failed?.values?.passes || 0,
    successRate: metrics.checks?.values?.passes / (metrics.checks?.values?.passes + metrics.checks?.values?.fails) || 0,
    p95Latency: metrics.http_req_duration?.values?.['p(95)'] || 0,
    p99Latency: metrics.http_req_duration?.values?.['p(99)'] || 0,
    avgLatency: metrics.http_req_duration?.values?.avg || 0,
    ordersCreated: metrics.orders_created?.values?.count || 0,
    ordersFailed: metrics.orders_failed?.values?.count || 0,
    orderCreationP95: metrics.order_creation_duration?.values?.['p(95)'] || 0,
    orderCreationP99: metrics.order_creation_duration?.values?.['p(99)'] || 0,
    thresholds: {
      p95LatencyPass: (metrics.http_req_duration?.values?.['p(95)'] || 0) < 500,
      p99LatencyPass: (metrics.http_req_duration?.values?.['p(99)'] || 0) < 1000,
      failureRatePass: (metrics.http_req_failed?.values?.rate || 0) < 0.01,
      checksPass: (metrics.checks?.values?.rate || 0) > 0.99,
      rpsPass: (metrics.http_reqs?.values?.rate || 0) >= 10000,
    },
  };

  return {
    'stdout': JSON.stringify(summary, null, 2),
    'summary.json': JSON.stringify(summary, null, 2),
  };
}