#!/bin/bash
set -e
cd packages/shared/api-client
dart run build_runner build --delete-conflicting-outputs
echo "API client generated from OpenAPI spec"
