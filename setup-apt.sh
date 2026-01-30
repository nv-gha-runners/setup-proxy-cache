#!/bin/bash
set -euo pipefail

# Use sudo only if available and not running as root
SUDO=""
if command -v sudo &> /dev/null && [ "${EUID:-$(id -u)}" -ne 0 ]; then
  SUDO="sudo"
fi

$SUDO sed -i 's|http://archive.ubuntu.com/ubuntu|https://ubuntu-archive-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources
$SUDO sed -i 's|http://security.ubuntu.com/ubuntu|https://ubuntu-security-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources
$SUDO sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://ubuntu-ports-cache.local.gha-runners.nvidia.com/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources
