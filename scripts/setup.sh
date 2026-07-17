#!/bin/bash
set -e

echo "=== Gloss Ecosystem Setup ==="

# Check prerequisites
command -v node >/dev/null 2>&1 || { echo "Node.js >=18 required"; exit 1; }
command -v flutter >/dev/null 2>&1 || { echo "Flutter >=3.19 required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Docker required"; exit 1; }

# Copy env file if not exists
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example — update values as needed"
fi

# Start infrastructure
docker compose up -d
echo "Waiting for PostgreSQL..."
sleep 5

# Install backend
cd packages/backend
npm install
cp .env.example .env 2>/dev/null || true
npx prisma generate
npx prisma migrate dev --name init
cd ../..

# Bootstrap Melos
dart pub global activate melos 2>/dev/null
melos bootstrap

# Generate API client
cd packages/shared/api-client
dart pub get
dart run build_runner build --delete-conflicting-outputs
cd ../../..

echo "=== Setup complete ==="
