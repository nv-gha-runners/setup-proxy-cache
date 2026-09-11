#!/usr/bin/env bash
set -euo pipefail

cache_url="${1:-}"
env_file="${GITHUB_ENV:-}"
user_home="${HOME:-}"

if [[ -z "${env_file}" ]]; then
  echo "GITHUB_ENV is required" >&2
  exit 1
fi

if [[ -z "${user_home}" ]]; then
  echo "HOME is required" >&2
  exit 1
fi

# Restrict the value to a plain HTTPS URL so it is safe to embed in XML and GITHUB_ENV.
if [[ ! "${cache_url}" =~ ^https://[A-Za-z0-9._:-]+(/[A-Za-z0-9._~/-]*)?$ ]]; then
  echo "maven-central-cache-url must be a plain HTTPS URL" >&2
  exit 1
fi

settings_dir="${user_home}/.m2"
settings_file="${settings_dir}/settings.xml"
mkdir -p "${settings_dir}"

if [[ -e "${settings_file}" || -L "${settings_file}" ]]; then
  echo "${settings_file} already exists; refusing to overwrite Maven configuration" >&2
  exit 1
fi

umask 077
cat >"${settings_file}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">
  <mirrors>
    <mirror>
      <id>nv-gha-runners-maven-central-cache</id>
      <name>NVIDIA GHA Runners Maven Central proxy cache</name>
      <url>${cache_url}</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF

printf 'NV_GHA_RUNNERS_MAVEN_CENTRAL_CACHE_URL=%s\n' "${cache_url}" >>"${env_file}"
