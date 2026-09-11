#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="${repo_root}/scripts/setup-maven-central.sh"
test_root="$(mktemp -d)"
trap 'rm -rf "${test_root}"' EXIT

export HOME="${test_root}/home"
export GITHUB_ENV="${test_root}/github-env"
mkdir -p "${HOME}"
touch "${GITHUB_ENV}"

cache_url="https://maven-cache.example.test/maven2"
"${script}" "${cache_url}"

settings_file="${HOME}/.m2/settings.xml"
grep -Fq "<url>${cache_url}</url>" "${settings_file}"
grep -Fq "<mirrorOf>central</mirrorOf>" "${settings_file}"
grep -Fq "NV_GHA_RUNNERS_MAVEN_CENTRAL_CACHE_URL=${cache_url}" "${GITHUB_ENV}"

if "${script}" "http://insecure.example.test/maven2" >/dev/null 2>&1; then
  echo "expected an insecure cache URL to be rejected" >&2
  exit 1
fi

if "${script}" "${cache_url}" >/dev/null 2>&1; then
  echo "expected an existing Maven settings file to be preserved" >&2
  exit 1
fi
