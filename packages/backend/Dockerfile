# ─────────────────────────────────────────────────────────
# Gloss Backend - Multi-stage Docker Build (Optimized <100MB)
# Build: docker build -t gloss-backend:latest --target runtime .
# ─────────────────────────────────────────────────────────

# ═══════════════════════════════════════════════════════════
# STAGE 1: Builder - Install deps & build
# ═══════════════════════════════════════════════════════════
FROM node:20-alpine AS builder

# Install build dependencies for native modules
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    openssl-dev \
    && npm config set python /usr/bin/python3

WORKDIR /app

# Copy package files first (better layer caching)
COPY package*.json ./

# Install production dependencies only
RUN npm ci --omit=dev --ignore-scripts --prefer-offline

# Copy Prisma schema & generate client
COPY prisma ./prisma/
RUN npx prisma generate

# Copy source code
COPY . .

# Build application
RUN npm run build

# ═══════════════════════════════════════════════════════════
# STAGE 2: Runtime - Distroless (minimal, secure, ~40MB)
# ═══════════════════════════════════════════════════════════
FROM gcr.io/distroless/nodejs20-debian12:nonroot AS runtime

# Labels for image metadata
LABEL org.opencontainers.image.title="Gloss Backend" \
      org.opencontainers.image.description="Gloss Ecosystem API Server" \
      org.opencontainers.image.vendor="Gloss" \
      org.opencontainers.image.source="https://github.com/gloss-ecosystem/gloss-ecosystem" \
      org.opencontainers.image.licenses="MIT"

WORKDIR /app

# Copy built application from builder
COPY --from=builder --chown=nonroot:nonroot /app/dist ./dist
COPY --from=builder --chown=nonroot:nonroot /app/node_modules ./node_modules
COPY --from=builder --chown=nonroot:nonroot /app/package.json ./
COPY --from=builder --chown=nonroot:nonroot /app/prisma ./prisma

# Use non-root user (distroless provides nonroot user)
USER nonroot

# Expose port
EXPOSE 3000

# Health check (distroless has no shell, use node)
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD ["node", "-e", "require('http').get('http://localhost:3000/health', (r) => { if (r.statusCode !== 200) process.exit(1) })"]

# Start application
CMD ["dist/main.js"]
