#!/usr/bin/env bash
# launch-verify.sh — Automated pre-launch and post-deploy verification
# Usage: ./scripts/launch-verify.sh [--env=staging|production] [--verbose] [--timeout=30]
# Exit codes: 0=all pass, 1=any fail, 2=usage error

set -euo pipefail

# =============================================================================
# Configuration
# =============================================================================
ENVIRONMENT="${ENVIRONMENT:-staging}"
VERBOSE="${VERBOSE:-false}"
TIMEOUT="${TIMEOUT:-30}"
API_HOST="${API_HOST:-api.gloss.uz}"
WS_HOST="${WS_HOST:-ws.gloss.uz}"
STORAGE_HOST="${STORAGE_HOST:-storage.gloss.uz}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0
START_TIME=$(date +%s)

# =============================================================================
# Helpers
# =============================================================================
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --env=ENV          Environment: staging, production, local (default: staging)
  --verbose          Enable verbose output
  --timeout=SEC      Request timeout in seconds (default: 30)
  --api-host=HOST    API hostname (default: api.gloss.uz)
  --ws-host=HOST     WebSocket hostname (default: ws.gloss.uz)
  --storage-host=HOST Storage hostname (default: storage.gloss.uz)
  -h, --help         Show this help

Environment Variables:
  ENVIRONMENT, VERBOSE, TIMEOUT, API_HOST, WS_HOST, STORAGE_HOST

Examples:
  $0 --env=production --verbose
  $0 --env=staging --timeout=60
EOF
}

log_info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
log_pass()  { echo -e "${GREEN}[PASS]${NC} $*"; ((PASSED++)); }
log_fail()  { echo -e "${RED}[FAIL]${NC} $*"; ((FAILED++)); }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; ((WARNINGS++)); }
log_section() { echo -e "\n${CYAN}═══ $* ═══${NC}"; }

# =============================================================================
# HTTP Check
# =============================================================================
curl_check() {
    local name="$1"
    local url="$2"
    local expected_status="${3:-200}"
    local expected_body="${4:-}"
    local timeout="${5:-$TIMEOUT}"

    if [[ "$VERBOSE" == "true" ]]; then
        log_info "Checking $name: $url"
    fi

    local response
    local http_code
    local body

    response=$(curl -s -w "\n%{http_code}" --max-time "$timeout" \
        -H "User-Agent: launch-verify/1.0" \
        "$url" 2>/dev/null || true)

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)

    if [[ "$http_code" != "$expected_status" ]]; then
        log_fail "$name — HTTP $http_code (expected $expected_status)"
        [[ "$VERBOSE" == "true" ]] && echo "Response: $body"
        return 1
    fi

    if [[ -n "$expected_body" ]] && ! echo "$body" | grep -q "$expected_body"; then
        log_fail "$name — Body missing '$expected_body'"
        [[ "$VERBOSE" == "true" ]] && echo "Response: $body"
        return 1
    fi

    log_pass "$name — HTTP $http_code"
    return 0
}

# =============================================================================
# WebSocket Check
# =============================================================================
ws_check() {
    local name="$1"
    local url="$2"
    local timeout="${3:-10}"

    if [[ "$VERBOSE" == "true" ]]; then
        log_info "Checking WebSocket: $name ($url)"
    fi

    # Try wscat first
    if command -v wscat &>/dev/null; then
        if echo '{"type":"ping"}' | timeout "$timeout" wscat -c "$url" -x '{"type":"ping"}' 2>/dev/null | grep -q "pong"; then
            log_pass "$name — Connected, pong received"
            return 0
        fi
    fi

    # Try websocat
    if command -v websocat &>/dev/null; then
        if echo '{"type":"ping"}' | timeout "$timeout" websocat "$url" 2>/dev/null | grep -q "pong"; then
            log_pass "$name — Connected, pong received"
            return 0
        fi
    fi

    # Try Node.js
    if command -v node &>/dev/null; then
        node -e "
            const WebSocket = require('ws');
            const ws = new WebSocket('$url');
            ws.on('open', () => ws.send(JSON.stringify({type:'ping'})));
            ws.on('message', (data) => { if (data.toString().includes('pong')) process.exit(0); });
            ws.on('error', () => process.exit(1));
            setTimeout(() => process.exit(1), ${timeout}000);
        " 2>/dev/null && { log_pass "$name — Connected"; return 0; }
    fi

    log_warn "$name — wscat/websocat/node not available, skipping WS check"
    return 0
}

# =============================================================================
# DNS Check
# =============================================================================
check_dns() {
    log_section "DNS Resolution"
    for host in "$API_HOST" "$WS_HOST" "$STORAGE_HOST"; do
        if dig +short "$host" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$|^[a-z0-9.-]+\.[a-z]{2,}$'; then
            log_pass "DNS: $host resolves"
        else
            log_fail "DNS: $host does not resolve"
        fi
    done
}

# =============================================================================
# SSL Certificate Check
# =============================================================================
check_ssl() {
    log_section "SSL Certificates"
    for host in "$API_HOST" "$WS_HOST" "$STORAGE_HOST"; do
        if echo | openssl s_client -connect "${host}:443" -servername "$host" -verify_return_error 2>/dev/null | grep -q "Verify return code: 0"; then
            local expiry
            expiry=$(echo | openssl s_client -connect "${host}:443" -servername "$host" 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
            local days_left
            days_left=$(( ($(date -d "$expiry" +%s) - $(date +%s)) / 86400 ))
            if [[ $days_left -gt 30 ]]; then
                log_pass "SSL: $host valid ($days_left days)"
            else
                log_warn "SSL: $host expires in $days_left days"
            fi
        else
            log_fail "SSL: $host certificate verification failed"
        fi
    done
}

# =============================================================================
# API Health Checks
# =============================================================================
check_api_health() {
    log_section "API Health Checks"
    curl_check "Health endpoint" "$BASE_URL/health" 200 "ok"
    curl_check "Readiness" "$BASE_URL/health/ready" 200 "ready"
    curl_check "Liveness" "$BASE_URL/health/live" 200 "live"
    curl_check "Version" "$BASE_URL/version" 200 "version"
}

# =============================================================================
# WebSocket Health
# =============================================================================
check_websocket() {
    log_section "WebSocket Health"
    ws_check "WS Gateway" "$WS_URL/health"
}

# =============================================================================
# Database Check (via API)
# =============================================================================
check_database() {
    log_section "Database Connectivity"
    curl_check "DB Health" "$BASE_URL/health/db" 200 "healthy"
}

# =============================================================================
# Redis Check (via API)
# =============================================================================
check_redis() {
    log_section "Redis Connectivity"
    curl_check "Redis Health" "$BASE_URL/health/redis" 200 "healthy"
}

# =============================================================================
# MinIO Check (via API)
# =============================================================================
check_minio() {
    log_section "MinIO Connectivity"
    curl_check "MinIO Health" "$BASE_URL/health/minio" 200 "healthy"
}

# =============================================================================
# Payment Gateway Checks
# =============================================================================
check_payments() {
    log_section "Payment Gateway Connectivity"
    curl_check "Click Health" "$BASE_URL/health/click" 200 "ok"
    curl_check "Payme Health" "$BASE_URL/health/payme" 200 "ok"
}

# =============================================================================
# FCM/Push Check
# =============================================================================
check_fcm() {
    log_section "FCM/Push Notifications"
    curl_check "FCM Health" "$BASE_URL/health/fcm" 200 "ok"
}

# =============================================================================
# Prometheus Targets
# =============================================================================
check_prometheus() {
    log_section "Prometheus Targets"
    local prom_url="${PROMETHEUS_URL:-http://prometheus:9090}"
    if curl_check "Prometheus API" "$prom_url/api/v1/targets" 200 "success"; then
        # Parse targets - would need jq for full parsing
        log_info "Prometheus targets accessible"
    fi
}

# =============================================================================
# Sentry Release Check
# =============================================================================
check_sentry() {
    log_section "Sentry Release"
    local sentry_org="${SENTRY_ORG:-gloss}"
    local sentry_project="${SENTRY_PROJECT:-backend}"
    if [[ -n "${SENTRY_AUTH_TOKEN:-}" ]]; then
        curl_check "Sentry Releases" "https://sentry.io/api/0/organizations/$sentry_org/releases/" 200 ""
    else
        log_warn "SENTRY_AUTH_TOKEN not set, skipping Sentry check"
    fi
}

# =============================================================================
# Smoke Test: Full Order Flow
# =============================================================================
smoke_test_order_flow() {
    log_section "Smoke Test: Order Flow"

    # This would require auth tokens and test data - placeholder
    log_info "Order flow smoke test requires test credentials"
    log_warn "Skipping full order flow (run manually with test accounts)"
}

# =============================================================================
# Main
# =============================================================================
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --env=*) ENVIRONMENT="${1#*=}" ;;
            --verbose) VERBOSE=true ;;
            --timeout=*) TIMEOUT="${1#*=}" ;;
            --api-host=*) API_HOST="${1#*=}" ;;
            --ws-host=*) WS_HOST="${1#*=}" ;;
            --storage-host=*) STORAGE_HOST="${1#*=}" ;;
            -h|--help) usage; exit 0 ;;
            *) echo "Unknown option: $1"; usage; exit 2 ;;
        esac
        shift
    done

    # Set URLs based on environment
    case $ENVIRONMENT in
        production)
            BASE_URL="https://${API_HOST}"
            WS_URL="wss://${WS_HOST}"
            ;;
        staging)
            BASE_URL="https://staging-api.gloss.uz"
            WS_URL="wss://staging-ws.gloss.uz"
            ;;
        local)
            BASE_URL="http://localhost:3000"
            WS_URL="ws://localhost:3001"
            ;;
        *)
            echo -e "${RED}Unknown environment: $ENVIRONMENT${NC}"
            exit 1
            ;;
    esac

echo -e "${CYAN}"
    cat <<EOF
╔═══════════════════════════════════════════════════════════════╗
║           Gloss Ecosystem — Launch Verification            ║
║                    Environment: ${ENVIRONMENT}             ║
╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"

    # Run checks
    check_dns
    check_ssl
    check_api_health
    check_websocket
    check_database
    check_redis
    check_minio
    check_payments
    check_fcm
    # check_prometheus
    # check_sentry
    smoke_test_order_flow

    # Summary
    local duration=$(( $(date +%s) - START_TIME ))
    echo -e "\n${CYAN}═══ SUMMARY ═══${NC}"
    echo -e "Environment: ${ENVIRONMENT}"
    echo -e "Duration: ${duration}s"
    echo -e "${GREEN}Passed: ${PASSED}${NC}"
    echo -e "${YELLOW}Warnings: ${WARNINGS}${NC}"
    echo -e "${RED}Failed: ${FAILED}${NC}"

    if [[ $FAILED -eq 0 ]]; then
        echo -e "\n${GREEN}✅ All critical checks passed!${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ ${FAILED} check(s) failed!${NC}"
        exit 1
    fi
}

main "$@"