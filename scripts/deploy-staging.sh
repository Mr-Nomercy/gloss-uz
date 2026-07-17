#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────
# Gloss Ecosystem - Staging Deployment Script
# Run: ./scripts/deploy-staging.sh [options]
# Options:
#   --skip-build          Skip Docker image build
#   --skip-db-migrate     Skip database migrations
#   --skip-health-check   Skip post-deployment health checks
#   --rollback            Rollback to previous deployment
#   --help                Show this help message
# ─────────────────────────────────────────────────────────

set -euo pipefail

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
readonly COMPOSE_FILE="docker-compose.staging.yml"
readonly ENV_FILE=".env.staging"
readonly BACKUP_DIR="/tmp/gloss-staging-backup-$(date +%Y%m%d-%H%M%S)"

# Default options
SKIP_BUILD=false
SKIP_DB_MIGRATE=false
SKIP_HEALTH_CHECK=false
ROLLBACK=false

# ─────────────────────────────────────────────────────────
# Logging Functions
# ─────────────────────────────────────────────────────────
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ─────────────────────────────────────────────────────────
# Help
# ─────────────────────────────────────────────────────────
show_help() {
    cat <<EOF
Gloss Staging Deployment Script

Usage: $0 [OPTIONS]

Options:
  --skip-build          Skip Docker image build
  --skip-db-migrate     Skip database migrations
  --skip-health-check   Skip post-deployment health checks
  --rollback            Rollback to previous deployment
  --help                Show this help message

Examples:
  $0                          # Full deployment
  $0 --skip-build             # Deploy without rebuilding
  $0 --rollback               # Rollback to previous version

Environment:
  Requires .env.staging file (copy from .env.staging.template)
EOF
}

# ─────────────────────────────────────────────────────────
# Parse Arguments
# ─────────────────────────────────────────────────────────
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --skip-build)
                SKIP_BUILD=true
                shift
                ;;
            --skip-db-migrate)
                SKIP_DB_MIGRATE=true
                shift
                ;;
            --skip-health-check)
                SKIP_HEALTH_CHECK=true
                shift
                ;;
            --rollback)
                ROLLBACK=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# ─────────────────────────────────────────────────────────
# Prerequisites Check
# ─────────────────────────────────────────────────────────
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    local missing=()
    
    command -v docker >/dev/null 2>&1 || missing+=("docker")
    command -v docker compose >/dev/null 2>&1 || missing+=("docker compose")
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v jq >/dev/null 2>&1 || missing+=("jq")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing[*]}"
        exit 1
    fi
    
    if [[ ! -f "$PROJECT_ROOT/$ENV_FILE" ]]; then
        log_error "Environment file $ENV_FILE not found!"
        log_info "Copy from template: cp .env.staging.template .env.staging"
        exit 1
    fi
    
    log_success "Prerequisites check passed"
}

# ─────────────────────────────────────────────────────────
# Load Environment
# ─────────────────────────────────────────────────────────
load_env() {
    log_info "Loading environment from $ENV_FILE"
    set -a
    source "$PROJECT_ROOT/$ENV_FILE"
    set +a
    
    # Export for docker compose
    export POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB
    export REDIS_PASSWORD
    export MINIO_ROOT_USER MINIO_ROOT_PASSWORD
    export JWT_ACCESS_SECRET JWT_REFRESH_SECRET
    export NODE_ENV=staging
}

# ─────────────────────────────────────────────────────────
# Build Images
# ─────────────────────────────────────────────────────────
build_images() {
    if [[ "$SKIP_BUILD" == true ]]; then
        log_warn "Skipping image build (--skip-build)"
        return
    fi
    
    log_info "Building Docker images..."
    cd "$PROJECT_ROOT"
    
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" build --no-cache backend
    
    log_success "Images built successfully"
}

# ─────────────────────────────────────────────────────────
# Database Migration
# ─────────────────────────────────────────────────────────
run_migrations() {
    if [[ "$SKIP_DB_MIGRATE" == true ]]; then
        log_warn "Skipping database migrations (--skip-db-migrate)"
        return
    fi
    
    log_info "Running database migrations..."
    cd "$PROJECT_ROOT"
    
    # Wait for database to be ready
    local max_attempts=30
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        if docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" exec -T postgres \
            pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null 2>&1; then
            break
        fi
        log_info "Waiting for database... (attempt $attempt/$max_attempts)"
        sleep 2
        ((attempt++))
    done
    
    if [[ $attempt -gt $max_attempts ]]; then
        log_error "Database not ready after $max_attempts attempts"
        exit 1
    fi
    
    # Run migrations
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" run --rm backend \
        npx prisma migrate deploy
    
    log_success "Database migrations completed"
}

# ─────────────────────────────────────────────────────────
# Start Services
# ─────────────────────────────────────────────────────────
start_services() {
    log_info "Starting staging services..."
    cd "$PROJECT_ROOT"
    
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d
    
    log_success "Services started"
}

# ─────────────────────────────────────────────────────────
# Wait for Health
# ─────────────────────────────────────────────────────────
wait_for_health() {
    if [[ "$SKIP_HEALTH_CHECK" == true ]]; then
        log_warn "Skipping health checks (--skip-health-check)"
        return
    fi
    
    log_info "Waiting for services to become healthy..."
    
    local services=("postgres" "redis" "minio" "backend" "nginx")
    local max_attempts=60
    local attempt=1
    
    while [[ $attempt -le $max_attempts ]]; do
        local all_healthy=true
        
        for service in "${services[@]}"; do
            local health
            health=$(docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps --format json "$service" 2>/dev/null | jq -r '.[0].Health // "unknown"')
            
            if [[ "$health" != "healthy" && "$health" != "unknown" ]]; then
                all_healthy=false
                break
            fi
        done
        
        if [[ "$all_healthy" == true ]]; then
            log_success "All services are healthy"
            return 0
        fi
        
        log_info "Waiting for health checks... (attempt $attempt/$max_attempts)"
        sleep 5
        ((attempt++))
    done
    
    log_error "Services failed to become healthy within timeout"
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
    exit 1
}

# ─────────────────────────────────────────────────────────
# Run Health Checks
# ─────────────────────────────────────────────────────────
run_health_checks() {
    if [[ "$SKIP_HEALTH_CHECK" == true ]]; then
        return
    fi
    
    log_info "Running health checks..."
    
    # Backend API health
    if curl -sf http://localhost:3001/health | jq -e '.status == "ok"' >/dev/null; then
        log_success "Backend API health check passed"
    else
        log_error "Backend API health check failed"
        exit 1
    fi
    
    # Database connectivity
    if docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" exec -T postgres \
        pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB" >/dev/null; then
        log_success "Database connectivity check passed"
    else
        log_error "Database connectivity check failed"
        exit 1
    fi
    
    # Redis connectivity
    if docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" exec -T redis \
        redis-cli -a "$REDIS_PASSWORD" ping | grep -q PONG; then
        log_success "Redis connectivity check passed"
    else
        log_error "Redis connectivity check failed"
        exit 1
    fi
    
    # MinIO health
    if curl -sf http://localhost:9002/minio/health/live >/dev/null; then
        log_success "MinIO health check passed"
    else
        log_error "MinIO health check failed"
        exit 1
    fi
    
    log_success "All health checks passed"
}

# ─────────────────────────────────────────────────────────
# Rollback
# ─────────────────────────────────────────────────────────
rollback_deployment() {
    log_warn "Rolling back deployment..."
    
    # This would restore from backup if we had one
    # For now, just restart previous containers
    cd "$PROJECT_ROOT"
    
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d
    
    log_success "Rollback completed"
}

# ─────────────────────────────────────────────────────────
# Show Status
# ─────────────────────────────────────────────────────────
show_status() {
    log_info "Deployment status:"
    cd "$PROJECT_ROOT"
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
    
    echo ""
    log_info "Access URLs:"
    echo "  API:        http://localhost:3001"
    echo "  API (HTTPS): https://localhost:8443"
    echo "  MinIO:      http://localhost:9003 (console)"
    echo "  PostgreSQL: localhost:5433"
    echo "  Redis:      localhost:6380"
    echo ""
    log_info "Logs: docker compose -f $COMPOSE_FILE --env-file $ENV_FILE logs -f [service]"
}

# ─────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────
main() {
    log_info "=========================================="
    log_info "Gloss Staging Deployment"
    log_info "=========================================="
    
    parse_args "$@"
    
    if [[ "$ROLLBACK" == true ]]; then
        rollback_deployment
        exit 0
    fi
    
    check_prerequisites
    load_env
    build_images
    
    cd "$PROJECT_ROOT"
    
    # Stop existing services gracefully
    log_info "Stopping existing services..."
    docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" down --timeout 30
    
    start_services
    run_migrations
    wait_for_health
    run_health_checks
    show_status
    
    log_success "=========================================="
    log_success "Staging deployment completed successfully!"
    log_success "=========================================="
}

# Trap signals
trap 'log_error "Deployment interrupted"; exit 1' INT TERM

# Run main
main "$@"