#!/usr/bin/env bash
# monitor-dashboard.sh — Quick access to launch monitoring dashboards
# Usage: ./scripts/monitor-dashboard.sh [--open] [--env=staging|production]

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

ENVIRONMENT="${ENVIRONMENT:-production}"
OPEN_BROWSER="${OPEN_BROWSER:-false}"

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --open)
            OPEN_BROWSER=true
            shift
            ;;
        --env=*)
            ENVIRONMENT="${1#*=}"
            shift
            ;;
        *)
            echo "Usage: $0 [--open] [--env=staging|production]"
            exit 1
            ;;
    esac
done

# Dashboard URLs
case $ENVIRONMENT in
    production)
        GRAFANA_BASE="https://grafana.gloss.uz"
        GRAFANA_ORG="gloss-prod"
        ;;
    staging)
        GRAFANA_BASE="https://grafana-staging.gloss.uz"
        GRAFANA_ORG="gloss-staging"
        ;;
    *)
        echo "Unknown environment: $ENVIRONMENT"
        exit 1
        ;;
esac

# Dashboard UIDs (set these after provisioning)
DASHBOARDS=(
    "launch-overview:Launch Overview"
    "api-golden-signals:API Golden Signals (RED)"
    "websocket-health:WebSocket Health"
    "business-kpis:Business KPIs"
    "payments:Payments Deep Dive"
    "database:Database Performance"
    "redis:Redis Cluster"
    "queues:Queue Depths & Processing"
    "infrastructure:Infrastructure Overview"
    "mobile:Mobile App Metrics"
    "security:Security & Auth"
)

# Open function
open_url() {
    local url="$1"
    local name="$2"

    if [[ "$OPEN_BROWSER" == "true" ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$url" 2>/dev/null &
        elif command -v open &> /dev/null; then
            open "$url" 2>/dev/null &
        elif command -v start &> /dev/null; then
            start "$url" 2>/dev/null &
        else
            echo "Cannot open browser automatically"
        fi
        echo -e "${GREEN}Opened:${NC} $name"
    else
        echo -e "${BLUE}$name:${NC} $url"
    fi
}

# Main
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Gloss Launch Monitoring Dashboards   ${NC}"
echo -e "${BLUE}  Environment: $ENVIRONMENT             ${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Build base URLs
GRAFANA_URL="${GRAFANA_BASE}"
if [[ "$ENVIRONMENT" == "staging" ]]; then
    ALERTMANAGER_URL="https://alertmanager-staging.gloss.uz"
    SENTRY_BASE="https://sentry-staging.gloss.uz"
    LOKI_URL="https://logs-staging.gloss.uz"
    TEMPO_URL="https://traces-staging.gloss.uz"
else
    ALERTMANAGER_URL="https://alertmanager.gloss.uz"
    SENTRY_BASE="https://sentry.gloss.uz"
    LOKI_URL="https://logs.gloss.uz"
    TEMPO_URL="https://traces.gloss.uz"
fi

echo -e "${YELLOW}Primary Dashboards:${NC}"
open_url "$GRAFANA_URL/d/launch-overview?orgId=1&refresh=30s&from=now-1h&to=now" "🚀 Launch Overview (LIVE)"
open_url "$GRAFANA_URL/d/api-golden-signals?orgId=1&refresh=30s&from=now-1h&to=now" "📊 API Golden Signals"
open_url "$GRAFANA_URL/d/websocket-health?orgId=1&refresh=10s&from=now-1h&to=now" "🔌 WebSocket Health"

echo -e "\n${YELLOW}Business & Payments:${NC}"
open_url "$GRAFANA_URL/d/business-kpis?orgId=1&refresh=60s&from=now-6h&to=now" "💰 Business KPIs"
open_url "$GRAFANA_URL/d/payments?orgId=1&refresh=30s&from=now-1h&to=now" "💳 Payments Deep Dive"

echo -e "\n${YELLOW}Infrastructure:${NC}"
open_url "$GRAFANA_URL/d/database?orgId=1&refresh=30s&from=now-1h&to=now" "🗄️ Database Performance"
open_url "$GRAFANA_URL/d/redis?orgId=1&refresh=30s&from=now-1h&to=now" "⚡ Redis Cluster"
open_url "$GRAFANA_URL/d/queues?orgId=1&refresh=30s&from=now-1h&to=now" "📬 Queue Depths"
open_url "$GRAFANA_URL/d/infrastructure?orgId=1&refresh=60s&from=now-1h&to=now" "☁️ Infrastructure"

echo -e "\n${YELLOW}Mobile & Security:${NC}"
open_url "$GRAFANA_URL/d/mobile?orgId=1&refresh=60s&from=now-6h&to=now" "📱 Mobile App Metrics"
open_url "$GRAFANA_URL/d/security?orgId=1&refresh=60s&from=now-6h&to=now" "🔒 Security & Auth"

echo -e "\n${YELLOW}Alerting & Logs:${NC}"
echo -e "${BLUE}Alertmanager:${NC} $ALERTMANAGER_URL"
echo -e "${BLUE}Sentry (Backend):${NC} $SENTRY_BASE/gloss/backend/"
echo -e "${BLUE}Sentry (Client):${NC} $SENTRY_BASE/gloss/client-app/"
echo -e "${BLUE}Sentry (Provider):${NC} $SENTRY_BASE/gloss/provider-app/"
echo -e "${BLUE}Sentry (Courier):${NC} $SENTRY_BASE/gloss/courier-app/"
echo -e "${BLUE}Sentry (Seller):${NC} $SENTRY_BASE/gloss/seller-app/"
echo -e "${BLUE}Loki (Logs):${NC} $LOKI_URL"
echo -e "${BLUE}Tempo (Traces):${NC} https://traces.gloss.uz"

echo -e "\n${YELLOW}Runbooks:${NC}"
echo -e "${BLUE}High Error Rate:${NC} docs/runbooks/high-error-rate.md"
echo -e "${BLUE}Payment Failures:${NC} docs/runbooks/payment-failures.md"
echo -e "${BLUE}WS Connection Issues:${NC} docs/runbooks/ws-connection-issues.md"
echo -e "${BLUE}DB Performance:${NC} docs/runbooks/db-performance.md"
echo -e "${BLUE}Queue Backlog:${NC} docs/runbooks/queue-backlog.md"
echo -e "${BLUE}Mobile Crash Rate:${NC} docs/runbooks/mobile-crash-rate.md"
echo -e "${BLUE}Rollback:${NC} docs/runbooks/rollback.md"

echo -e "\n${YELLOW}Key CLI Commands:${NC}"
echo -e "  ${GREEN}./scripts/launch-verify.sh --env=$ENVIRONMENT --verbose${NC}  # Run verification"
echo -e "  ${GREEN}kubectl get pods -n gloss-prod -w${NC}                         # Watch pod status"
echo -e "  ${GREEN}kubectl top pods -n gloss-prod${NC}                            # Resource usage"
echo -e "  ${GREEN}stern -n gloss-prod backend${NC}                               # Tail backend logs"
echo -e "  ${GREEN}stern -n gloss-prod websocket${NC}                             # Tail WS logs"
echo -e "  ${GREEN}kubectl exec -it pg-primary -- pg_stat_activity${NC}           # DB connections"

if [[ "$OPEN_BROWSER" == "true" ]]; then
    echo -e "\n${GREEN}Opening all dashboards in browser...${NC}"
    sleep 2
fi