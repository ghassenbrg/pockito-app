#!/usr/bin/env bash
# Builds the immutable Keycloak image that carries all Pockito customer themes.
# Set PUSH=1 in CI/release automation to publish it after a successful build.
#
# This is the local/manual entry point. Production builds and rollouts of
# auth.ghassen.io go through the ghassen-io-infra repository, which builds this
# same Dockerfile from a checkout of this repo:
#
#   Actions -> "Pockito Deploy" -> component: keycloak
#   ghassen-io-infra/keycloak/scripts/build.sh
#
# Both paths therefore produce repo.ghassen.io/library/pockito-keycloak, and
# the Keycloak version is read from the Dockerfile's ARG rather than restated.
set -euo pipefail

repo_root=$(cd "$(dirname "$0")/../.." && pwd)
dockerfile="$repo_root/infra/keycloak/Dockerfile"
# The Dockerfile's ARG is the single source of truth for the Keycloak version.
default_version=$(sed -n 's/^ARG[[:space:]]\{1,\}KEYCLOAK_VERSION=\(.*\)$/\1/p' "$dockerfile" | head -1)
keycloak_version=${KEYCLOAK_VERSION:-$default_version}
# The cluster pulls from Harbor. Building under a different registry by default
# produced an image nothing deploys.
image_registry=${REGISTRY:-repo.ghassen.io/library}
image_tag=${KEYCLOAK_TAG:-${keycloak_version}-pockito}
image_name=${KEYCLOAK_IMAGE:-${image_registry}/pockito-keycloak:${image_tag}}
# The k3s node is amd64. An arm64 image built on an Apple Silicon laptop only
# fails at run time, as a CrashLoopBackOff on the node.
platform=${PLATFORM:-linux/amd64}

docker build \
  --platform "$platform" \
  -f "$dockerfile" \
  --build-arg "KEYCLOAK_VERSION=$keycloak_version" \
  -t "$image_name" \
  "$repo_root"

# A COPY that silently copied nothing would otherwise only show up as an
# unstyled login page in production.
docker run --rm --platform "$platform" --entrypoint sh "$image_name" \
  -c 'test -f /opt/keycloak/themes/pockito/login/theme.properties'

if test "${PUSH:-0}" = "1"; then
  docker push "$image_name"
fi

echo "Built $image_name"
