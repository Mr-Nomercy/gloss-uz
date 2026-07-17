import ws from 'k6/ws';
import { check, sleep } from 'k6';
import { Rate, Trend, Counter, Gauge } from 'k6/metrics';

export const options = {
  scenarios: {
    websocket_connections: {
      executor: 'ramping-vus',
      startVUs: 100,
      stages: [
        { duration: '2m', target: 1000 },
        { duration: '3m', target: 3000 },
        { duration: '5m', target: 5000 },
        { duration: '10m', target: 5000 },
        { duration: '3m', target: 3000 },
        { duration: '2m', target: 1000 },
        { duration: '1m', target: 0 },
      ],
      gracefulRampDown: '30s',
    },
  },
  thresholds: {
    ws_connecting: ['p(95)<2000'],
    ws_session_duration: ['p(95)>300000'],
    ws_messages_received: ['rate>100'],
    ws_ping_latency: ['p(95)<100'],
    checks: ['rate>0.99'],
    'ws_connection_errors': ['rate<0.01'],
  },
  ext: {
    loadimpact: {
      projectID: __ENV.K6_PROJECT_ID,
      name: 'WebSocket Load Test - 5k Connections',
    },
  },
};

const WS_URL = __ENV.WS_URL || 'ws://localhost:3000/api/v1';
const AUTH_TOKEN = __ENV.AUTH_TOKEN || '';

const activeConnections = new Gauge('ws_active_connections');
const connectionsEstablished = new Counter('ws_connections_established');
const connectionsFailed = new Counter('ws_connections_failed');
const messagesSent = new Counter('ws_messages_sent');
const messagesReceived = new Counter('ws_messages_received');
const pingLatency = new Trend('ws_ping_latency');
const connectionErrors = new Rate('ws_connection_errors');
const messageLatency = new Trend('ws_message_latency');

const ORDER_ID = __ENV.ORDER_ID || 'test-order-id';

export function setup() {
  const http = __ENV.K6_HTTP || require('k6/http');
  const res = http.get(`${WS_URL.replace('ws://', 'http://').replace('wss://', 'https://')}/health`);
  if (res.status !== 200) {
    throw new Error(`Health check failed: ${res.status}`);
  }
  console.log('Health check passed');
  return { wsUrl: WS_URL, token: AUTH_TOKEN, orderId: ORDER_ID };
}

export default function (data) {
  const url = `${data.wsUrl}/orders?token=${data.token}`;
  const params = {
    tags: { name: 'OrdersWebSocket' },
  };

  const res = ws.connect(url, params, (socket) => {
    activeConnections.add(1);
    connectionsEstablished.add(1);

    socket.on('open', () => {
      console.log(`Connected: ${socket.url}`);
      
      socket.setInterval(() => {
        const start = new Date();
        socket.ping();
        const latency = new Date() - start;
        pingLatency.add(latency);
      }, 10000);

      socket.setInterval(() => {
        const message = JSON.stringify({
          event: 'order:status',
          data: { orderId: data.orderId, status: 'ping' },
        });
        socket.send(message);
        messagesSent.add(1);
      }, 5000);
    });

    socket.on('message', (msg) => {
      messagesReceived.add(1);
      try {
        const parsed = JSON.parse(msg);
        if (parsed.event === 'pong') {
          const latency = new Date() - new Date(parsed.timestamp);
          pingLatency.add(latency);
        }
      } catch (e) {
      }
    });

    socket.on('pong', () => {
      const latency = new Date() - socket.__pingStart;
      pingLatency.add(latency);
    });

    socket.on('close', () => {
      activeConnections.add(-1);
      console.log(`Disconnected: ${socket.url}`);
    });

    socket.on('error', (e) => {
      connectionErrors.add(1);
      activeConnections.add(-1);
      console.error(`Socket error: ${e.error()}`);
    });

    socket.setTimeout(() => {
      socket.close();
    }, 600000);
  });

  check(res, {
    'connection established': (r) => r && r.status === 101,
  }) || connectionErrors.add(1);

  if (!res || res.status !== 101) {
    connectionsFailed.add(1);
  }

  sleep(1);
}

export function teardown(data) {
  console.log('WebSocket load test completed');
  console.log(`Total connections established: ${connectionsEstablished.values.count}`);
  console.log(`Total connections failed: ${connectionsFailed.values.count}`);
  console.log(`Total messages sent: ${messagesSent.values.count}`);
  console.log(`Total messages received: ${messagesReceived.values.count}`);
}

export function handleSummary(data) {
  const { metrics } = data;
  const summary = {
    timestamp: new Date().toISOString(),
    test: 'websocket-load-test',
    targetConnections: 5000,
    duration: metrics.ws_session_duration?.values?.max || 0,
    connectionsEstablished: metrics.ws_connections_established?.values?.count || 0,
    connectionsFailed: metrics.ws_connections_failed?.values?.count || 0,
    messagesSent: metrics.ws_messages_sent?.values?.count || 0,
    messagesReceived: metrics.ws_messages_received?.values?.count || 0,
    avgPingLatency: metrics.ws_ping_latency?.values?.avg || 0,
    p95PingLatency: metrics.ws_ping_latency?.values?.['p(95)'] || 0,
    p99PingLatency: metrics.ws_ping_latency?.values?.['p(99)'] || 0,
    connectionErrorRate: metrics.ws_connection_errors?.values?.rate || 0,
    avgMessageLatency: metrics.ws_message_latency?.values?.avg || 0,
    thresholds: {
      connectionTimePass: (metrics.ws_connecting?.values?.['p(95)'] || 0) < 2000,
      sessionDurationPass: (metrics.ws_session_duration?.values?.['p(95)'] || 0) > 300000,
      messageRatePass: (metrics.ws_messages_received?.values?.rate || 0) > 100,
      pingLatencyPass: (metrics.ws_ping_latency?.values?.['p(95)'] || 0) < 100,
      checksPass: (metrics.checks?.values?.rate || 0) > 0.99,
      errorRatePass: (metrics.ws_connection_errors?.values?.rate || 0) < 0.01,
    },
  };

  return {
    'stdout': JSON.stringify(summary, null, 2),
    'ws-summary.json': JSON.stringify(summary, null, 2),
  };
}