# Gloss Ecosystem - DNS Configuration for Blue-Green Deployment

## Overview
This document describes the DNS configuration required for the Gloss Ecosystem production and staging environments with blue-green deployment support.

## Domain Structure

### Production Domains
| Domain | Purpose | Target |
|--------|---------|--------|
| `gloss.uz` | Main landing page | CloudFlare / Static Hosting |
| `api.gloss.uz` | API Backend | Nginx Ingress (Blue-Green) |
| `client.gloss.uz` | Client Flutter Web App | Nginx Ingress |
| `provider.gloss.uz` | Provider/Courier Flutter Web App | Nginx Ingress |
| `seller.gloss.uz` | Seller Flutter Web App | Nginx Ingress |
| `admin.gloss.uz` | Admin Dashboard | Nginx Ingress |
| `minio.gloss.uz` | MinIO Console (VPN only) | Nginx Ingress |
| `grafana.gloss.uz` | Grafana Monitoring (VPN only) | Nginx Ingress |
| `prometheus.gloss.uz` | Prometheus (VPN only) | Nginx Ingress |

### Staging Domains
| Domain | Purpose | Target |
|--------|---------|--------|
| `staging.gloss.uz` | Staging landing page | CloudFlare / Static Hosting |
| `staging-api.gloss.uz` | Staging API Backend | Nginx Ingress |
| `staging-client.gloss.uz` | Staging Client App | Nginx Ingress |
| `staging-provider.gloss.uz` | Staging Provider App | Nginx Ingress |
| `staging-seller.gloss.uz` | Staging Seller App | Nginx Ingress |

## Blue-Green DNS Strategy

### Option 1: Ingress-Based Switching (Recommended)
Traffic switching happens at the Nginx Ingress level, not DNS level. DNS always points to the same Ingress IP.

**Production:**
```
api.gloss.uz     A     <Ingress-NGINX-EXTERNAL-IP>   (TTL: 300)
client.gloss.uz  A     <Ingress-NGINX-EXTERNAL-IP>   (TTL: 300)
provider.gloss.uz A    <Ingress-NGINX-EXTERNAL-IP>   (TTL: 300)
seller.gloss.uz  A     <Ingress-NGINX-EXTERNAL-IP>   (TTL: 300)
```

**Staging:**
```
staging-api.gloss.uz    A    <Staging-Ingress-IP>    (TTL: 300)
staging-client.gloss.uz A    <Staging-Ingress-IP>    (TTL: 300)
staging-provider.gloss.uz A  <Staging-Ingress-IP>    (TTL: 300)
staging-seller.gloss.uz A    <Staging-Ingress-IP>    (TTL: 300)
```

### Option 2: DNS-Based Switching (Alternative)
For faster rollback without Ingress reload, use two sets of DNS records with different weights.

**Production Blue:**
```
api.gloss.uz     A     <Blue-LoadBalancer-IP>     (Weight: 100, TTL: 60)
api-blue.gloss.uz  A   <Blue-LoadBalancer-IP>     (TTL: 60)
```

**Production Green:**
```
api-green.gloss.uz A   <Green-LoadBalancer-IP>    (TTL: 60)
```

Switch by updating `api.gloss.uz` to point to Green IP.

## CloudFlare Configuration

### DNS Records (Production)
```bash
# Main API (proxied through CloudFlare)
TYPE    NAME      CONTENT                    PROXY    TTL
A       @         <Ingress-IP>               Proxied  Auto
A       api       <Ingress-IP>               Proxied  Auto
CNAME   client    client.gloss.uz            Proxied  Auto
CNAME   provider  provider.gloss.uz          Proxied  Auto
CNAME   seller    seller.gloss.uz            Proxied  Auto
CNAME   admin     admin.gloss.uz             Proxied  Auto
CNAME   minio     minio.gloss.uz             DNS Only Auto
CNAME   grafana   grafana.gloss.uz           DNS Only Auto

# Blue-Green specific (for debugging)
A       api-blue    <Blue-LB-IP>              DNS Only 60
A       api-green   <Green-LB-IP>             DNS Only 60
```

### CloudFlare Page Rules
1. **API Caching Bypass**: `api.gloss.uz/*` - Cache Level: Bypass
2. **WebSocket Support**: `api.gloss.uz/socket.io/*` - Cache Level: Bypass, Edge Cache TTL: 0
3. **Security**: `*.gloss.uz/*` - Security Level: High, Browser Integrity Check: On
4. **SSL**: `*.gloss.uz/*` - Always Use HTTPS: On, Automatic HTTPS Rewrites: On

### CloudFlare Workers (Optional - Blue-Green at Edge)
```javascript
// Worker for blue-green traffic splitting
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const url = new URL(request.url)
  
  // Route based on cookie or header
  const color = request.headers.get('x-deployment-color') || 'blue'
  const backend = color === 'green' 
    ? 'https://api-green.gloss.uz' 
    : 'https://api-blue.gloss.uz'
  
  return fetch(`${backend}${url.pathname}${url.search}`, {
    method: request.method,
    headers: request.headers,
    body: request.body,
    redirect: 'manual'
  })
}
```

## SSL/TLS Configuration

### Let's Encrypt (cert-manager)
```yaml
# Production ClusterIssuer
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@gloss.uz
    privateKeySecretRef:
      name: letsencrypt-prod-private-key
    solvers:
      - http01:
          ingress:
            class: nginx
        selector:
          dnsNames:
            - "*.gloss.uz"
            - "gloss.uz"
```

### Certificate Resources (Auto-created by cert-manager)
```yaml
# Example - auto-generated for api.gloss.uz
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gloss-api-tls
  namespace: gloss-production
spec:
  secretName: gloss-api-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
  dnsNames:
    - api.gloss.uz
    - gloss.uz
```

## Health Check Endpoints

### Blue Environment
```
GET https://api-blue.gloss.uz/health
GET https://api-blue.gloss.uz/health/db
GET https://api-blue.gloss.uz/health/redis
```

### Green Environment
```
GET https://api-green.gloss.uz/health
GET https://api-green.gloss.uz/health/db
GET https://api-green.gloss.uz/health/redis
```

### Active (Load Balanced)
```
GET https://api.gloss.uz/health
Response: {"status":"ok","color":"blue","version":"1.0.0","timestamp":"2024-01-15T10:30:00Z"}
```

## Deployment Verification Checklist

### Pre-Deployment
- [ ] DNS records created and propagated
- [ ] SSL certificates issued (check cert-manager)
- [ ] Ingress controllers running
- [ ] Blue and Green namespaces exist
- [ ] Secrets and ConfigMaps applied
- [ ] Database migrations ready

### Post-Deployment (Blue → Green)
- [ ] Green pods running and healthy (3/3 replicas)
- [ ] Green health checks passing
- [ ] Smoke tests passing on Green
- [ ] Ingress updated to route to Green
- [ ] Traffic verified on Green (check logs)
- [ ] Blue pods scaled to 0 (after verification period)
- [ ] Monitoring alerts configured for Green

### Rollback Procedure
1. Update Ingress to route back to Blue
2. Verify Blue health checks
3. Scale Green to 0
4. Investigate Green failure

## Monitoring DNS Changes

```bash
# Watch DNS propagation
watch -n 10 'dig +short api.gloss.uz @1.1.1.1'

# Check SSL certificate
openssl s_client -connect api.gloss.uz:443 -servername api.gloss.uz </dev/null

# Verify cert-manager
kubectl get certificates -n gloss-production
kubectl describe certificate gloss-api-tls -n gloss-production
```

## Emergency Contacts
- **DNS Provider**: CloudFlare / Your Registrar
- **SSL Issues**: cert-manager logs, Let's Encrypt rate limits
- **Ingress Issues**: NGINX Ingress Controller logs
- **Deployment Issues**: Runbook in `/docs/runbooks/deployment-issues.md`