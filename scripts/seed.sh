#!/bin/bash
cd packages/backend
npx prisma db seed
echo "Database seeded with test data"
