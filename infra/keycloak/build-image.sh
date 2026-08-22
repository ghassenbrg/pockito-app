#!/usr/bin/env bash
# Builds the immutable Keycloak image that carries all Pockito customer themes.
# Set PUSH=1 in CI/release automation to publish it after a successful build.
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../.." && pwd)
keycloak_version=${KEYCLOAK_VERSION:-26.4.7}
image_registry=${REGISTRY:-ghassenbrg}
image_tag=${KEYCLOAK_TAG:-${keycloak_version}-pockito}
image_name=${KEYCLOAK_IMAGE:-${image_registry}/pockito-keycloak:${image_tag}}

docker build \
  -f "$repo_root/infra/keycloak/Dockerfile" \
  --build-arg "KEYCLOAK_VERSION=$keycloak_version" \
  -t "$image_name" \
  "$repo_root"

if test "${PUSH:-0}" = "1"; then
  docker push "$image_name"
fi

echo "Built $image_name"
