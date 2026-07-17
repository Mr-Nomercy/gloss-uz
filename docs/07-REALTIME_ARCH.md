# Realtime Architecture — Gloss Ecosystem

## Overview

Three WebSocket gateways in NestJS, all behind a single Socket.io server.

```
┌─────────────────────────────────────────────────────┐
│                  Socket.io Server                    │
│                    (NestJS)                          │
│                        │                             │
│         ┌──────────────┼──────────────┐             │
│         ▼              ▼              ▼             │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐        │
│  │  Orders   │ │  Tracking │ │   Chat    │        │
│  │  Gateway  │ │  Gateway  │ │  Gateway  │        │
│  └───────────┘ └───────────┘ └───────────┘        │
│         │              │              │             │
│         ▼              ▼              ▼             │
│  ┌───────────────────────────────────────────┐     │
│  │          Redis Adapter (Pub/Sub)           │     │
│  │  For horizontal scaling (MANDATORY for production) │     │
│  └───────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────┘
```

## Connection Authentication

```
Client → Socket.io handshake:
  Auth: JWT in Socket.io handshake BODY only (`auth.token`). NEVER in query parameters (query params are logged by load balancers).

Server validates:
  1. JWT signature + expiration
  2. User status (isActive, isBlocked)
  3. Role claim exists
  4. Rate limit check per user

On successful auth:
  - Join user-specific room: user:<userId>
- Join role-specific room: role:<activeRole>
- Subscribe to relevant order rooms
```

### Redis Presence Management (instead of DB)
Courier/provider online/offline state stored in Redis (not DB):
- Key: `presence:{userId}` with TTL = 60 seconds
- Auto-refresh on each WS heartbeat
- On disconnect, TTL expiry auto-removes presence
- Pub/sub: presence changes broadcast to all instances
- This replaces `CourierProfile.isOnline` / `ProviderProfile.isAvailable` DB writes
```

## Namespaces

| Namespace | Path | Purpose | Auth |
|-----------|------|---------|------|
| Orders | `/ws/orders` | Order status, assignments | JWT required |
| Tracking | `/ws/tracking` | Courier location, ETA | JWT required |
| Chat | `/ws/chat` | Messages, typing, read | JWT required |
| Notifications | `/ws/notifications` | Push fallback, real-time alerts | JWT required |

## Event Definitions

### Orders Gateway (`/ws/orders`)

#### Client → Server

| Event | Payload | Who | Description |
|-------|---------|-----|-------------|
| `order:subscribe` | `{ orderId }` | Client, Provider, Courier | Listen to order updates |
| `order:unsubscribe` | `{ orderId }` | Client, Provider, Courier | Stop listening |
| `order:accept` | `{ orderId }` | Provider, Courier | Accept assigned order |

#### Server → Client

| Event | Payload | Who Receives | Description |
|-------|---------|--------------|-------------|
| `order:created` | `{ order, estimatedAssignmentDelay }` | Client | Order created successfully |
| `order:available` | `{ order, score, distance, eta }` | Providers (geo) | New order for nearby providers |
| `order:assigned:provider` | `{ order, provider, eta }` | Client, Provider | Provider accepted |
| `order:assigned:courier` | `{ order, courier, eta }` | Client, Courier | Courier assigned |
| `order:status_changed` | `{ orderId, from, to, timestamp, by }` | All participants | Status transition |
| `order:cancelled` | `{ orderId, reason, by }` | All participants | Cancellation notice |
| `order:completed` | `{ orderId, total, reviewPrompt }` | Client | Order done |
| `order:reassigned` | `{ orderId, newProvider?, newCourier?, reason }` | All participants | Reassignment |

### Tracking Gateway (`/ws/tracking`) — Yandex Go Style

#### Courier → Server

| Event | Payload | Interval | Description |
|-------|---------|----------|-------------|
| `location:update` | `{ orderId, lat, lng, accuracy, speed, heading, battery, timestamp }` | Every 3-5 seconds | Courier location stream |
| `tracking:status` | `{ orderId, status, timestamp, metadata? }` | On transition | Status: en_route_to_pickup → at_pickup → en_route_to_delivery → at_delivery → completed |

#### Server → Client (Courier consumer)

| Event | Payload | Who Receives | Description |
|-------|---------|--------------|-------------|
| `tracking:started` | `{ orderId, courier: { id, name, phone, rating, avatar, vehicle }, estimatedPickup, routePolyline }` | Client, Provider | Courier started moving |
| `tracking:location` | `{ orderId, lat, lng, estimatedArrival, distanceKm, speed, heading }` | Client, Provider | Real-time position |
| `tracking:eta_update` | `{ orderId, estimatedArrival, distanceKm, trafficLevel }` | Client | Updated ETA |
| `tracking:arrived` | `{ orderId, locationType: 'pickup' \| 'delivery', address }` | Client, Provider, Seller | Arrival notice |
| `tracking:status` | `{ orderId, status, timestamp, metadata }` | Client, Provider | Status change |
| `tracking:completed` | `{ orderId, deliveredPhoto?, signature?, dropoffTime }` | Client, Provider, Seller | Delivery done |
| `tracking:courier_offline` | `{ orderId, reason: 'battery' \| 'connection' \| 'manual' }` | Client | Courier disconnected |

### Chat Gateway (`/ws/chat`)

#### Client → Server

| Event | Payload | Description |
|-------|---------|-------------|
| `chat:join` | `{ chatId }` | Join chat room |
| `chat:leave` | `{ chatId }` | Leave chat room |
| `chat:message` | `{ chatId, type, content, metadata }` | Send message |
| `chat:read` | `{ chatId, messageId }` | Mark as read |
| `chat:typing` | `{ chatId, isTyping }` | Typing indicator |
| `chat:message:delete` | `{ chatId, messageId }` | Delete own message |

#### Server → Client

| Event | Payload | Description |
|-------|---------|-------------|
| `chat:message_new` | `{ message: { id, chatId, fromUser, type, content, metadata, createdAt } }` | New message |
| `chat:message_read` | `{ messageId, readBy, readAt }` | Read receipt |
| `chat:user_typing` | `{ chatId, userId, userName, isTyping }` | Typing indicator |
| `chat:system_message` | `{ chatId, type: 'order_status' \| 'payment' \| 'info', content }` | System message |
| `chat:message_deleted` | `{ chatId, messageId }` | Deleted notice |

### Notifications Gateway (`/ws/notifications`)

#### Server → Client

| Event | Payload | Description |
|-------|---------|-------------|
| `notification:new` | `{ notification: { id, type, title, body, data } }` | Real-time notification |
| `notification:badge` | `{ total: 5 }` | Badge count update |

## Room Hierarchy

```
Global rooms:
  role:client            — All clients
  role:provider          — All providers
  role:courier           — All couriers
  role:seller            — All sellers
  role:admin             — All admins

Per-user rooms:
  user:<userId>          — Personal notifications

Per-order rooms:
  order:<orderId>        — Order-specific (client, provider, courier)

Per-chat rooms:
  chat:<chatId>          — Chat-specific participants

Geo rooms (for assignment):
  geo:provider:<city>    — Provider pool per city
  geo:courier:<city>     — Courier pool per city
```

## Assignment Flow (Yandex Go Style)

```
Order Created (type: service)
    │
    ▼
Find nearby available providers (radius: 3km)
    │
    ▼
Calculate score for each: distance × rating × current_load
    │
    ▼
Send order:available to top 5 providers (score > threshold)
    │
    ▼
┌─────────────────────────────────────────────┐
│              WAITING (5 seconds)              │
│  Any provider accepts?                       │
└─────────────────────────────────────────────┘
    │                    │
   YES                  NO
    │                    │
    ▼                    ▼
Assign provider    Expand radius to 5km
Notify client      Send to next 5 providers
                   repeat (max 3 expansions)
                          │
                          ▼
                   If still no → notify admin
                   for manual dispatch
```

## Chat + Order Integration

When order status changes:
1. Client, provider, courier, seller receive `order:status_changed` via WS
2. System message auto-generated in order chat: `"Order status: In Progress"` → `chat:system_message`
3. Push notification sent via FCM (if app in background)
4. Badge count updated

## Error Handling

| Error | Handler | User Impact |
|-------|---------|-------------|
| Disconnect | Auto-reconnect (exponential backoff: 1s, 2s, 4s, 8s, max 30s) | Brief delay, state synced on reconnect |
| Auth failure | Emit `error:auth` → client forces re-login | Intermittent |
| Rate limit | Emit `error:rate_limit` → client throttles | Message delayed |
| Server restart | Redis adapter preserves rooms; clients reconnect | Brief interruption |

## Reconnection Strategy

- Exponential backoff: 1s, 2s, 4s, 8s, max 30s
- Auto-reconnect enabled by default (Socket.io `enableAutoConnect()`)
- State synced on reconnect via room resubscription
- On each reconnect attempt: server re-validates JWT from `auth.token`
- If JWT expired on reconnect → client forces re-login

### Heartbeat & Keepalive
- Socket.io built-in: `pingInterval = 25000ms`, `pingTimeout = 60000ms`
- Client-side heartbeat: no custom implementation needed (Socket.io handles this)
- Server-side: if no ping response within pingTimeout, disconnect and clean up room subscriptions
- Connection health exposed via `connectionState` Riverpod provider (connected | disconnected | reconnecting)

### Room Resubscription
On reconnect, the client MUST resubscribe to all previously joined rooms:
1. Client stores active room subscriptions in memory (Set<String>)
2. On `connect` event, emit all stored room subscriptions:
   - `order:subscribe` for each active order
   - `chat:join` for each active chat
   - `geo:subscribe` for active tracking
3. Server confirms each subscription with an `ack` event
4. If any subscription fails (e.g., order completed while disconnected), client handles gracefully

## Offline Message Queue
Messages emitted while WebSocket is disconnected are NOT lost:

1. **Client-side queue**: All outbound events (location updates, chat messages, typing indicators) are queued in-memory during disconnection
2. **On reconnect**: Queue is replayed in FIFO order with exponential backoff per message
3. **Expiry**: Location updates older than 30 seconds are dropped (stale data)
4. **Chat messages**: Never dropped — resubmitted with original `clientMsgId` for deduplication
5. **Deduplication**: Server rejects messages with duplicate `clientMsgId` within 5-minute window

## Flutter Client Integration

```dart
// Socket client wrapper
class SocketClient {
  late final Socket socket;

  SocketClient(String url, {String? token}) {
    socket = io(url, OptionBuilder()
      .setTransports(WebSocket())
      .setAuth({'token': token})
      .enableAutoConnect()
      .build());

    socket.onConnect((_) => _onConnected());
    socket.onDisconnect((_) => _onDisconnected());
    socket.onError((data) => _onError(data));
  }

  void subscribeOrder(String orderId) {
    socket.emit('order:subscribe', {'orderId': orderId});
  }

  void sendLocation(LocationUpdate update) {
    socket.emit('location:update', update.toJson());
  }

  Stream<LocationData> get locationStream => socket
      .onEvent('tracking:location')
      .map((data) => LocationData.fromJson(data));

  Stream<OrderStatus> get orderStatusStream => socket
      .onEvent('order:status_changed')
      .map((data) => OrderStatus.fromJson(data));
}
```

### Connection Health
- `socket.connected` → connected state
- `socket.disconnected` → disconnected, queue messages, start reconnect
- `socket.io.ping` → no action (internal)
- `socket.io.pong` → update latency display (`socket.io.engine.transport` for transport type)
- After 3 consecutive ping timeouts → force socket close and restart connection cycle

### Connectivity Provider (Riverpod)
```dart
@riverpod
class WSConnection extends _$WSConnection {
  @override
  ConnectionState build() => ConnectionState.disconnected;
  
  void onConnect() => state = ConnectionState.connected;
  void onDisconnect() => state = ConnectionState.disconnected;
  void onReconnecting() => state = ConnectionState.reconnecting;
}

enum ConnectionState { connected, disconnected, reconnecting }
```

## FCM Integration (Push Fallback)

When app is in background/killed, FCM delivers notifications:

```
Order assigned → FCM to courier/provider
  └── Tapping notification → deep link to order page

Chat message → FCM to recipient
  └── Tapping → deep link to chat page

Payment success → FCM to client
  └── Tapping → deep link to order detail
```

Push payload format:

```json
{
  "notification": {
    "title": "Yangi buyurtma",
    "body": "Sizga №123 buyurtma tayinlandi"
  },
  "data": {
    "type": "order_assigned",
    "orderId": "abc123",
    "deepLink": "/orders/abc123"
  }
}
```
