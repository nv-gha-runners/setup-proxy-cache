#!/bin/bash
set -euo pipefail

# Only run on Ubuntu
if ! grep -q "^ID=ubuntu" /etc/os-release 2>/dev/null; then
  echo "Not Ubuntu, skipping apt cache setup"
  exit 0
fi

# Skip if sed isn't available
if ! command -v sed >/dev/null 2>&1; then
  echo "sed not found, skipping apt cache setup"
  exit 0
fi

# Figure out if we need sudo
SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
fi

# Configure apt to use cache servers
# Try new format first (Ubuntu 22.04+), fall back to old format
if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then
  $SUDO sed -i 's|http://archive.ubuntu.com/ubuntu|https://ubuntu-archive-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources
  $SUDO sed -i 's|http://security.ubuntu.com/ubuntu|https://ubuntu-security-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list.d/ubuntu.sources
  $SUDO sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://ubuntu-ports-cache.local.gha-runners.nvidia.com/ubuntu-ports|g' /etc/apt/sources.list.d/ubuntu.sources
elif [ -f /etc/apt/sources.list ]; then
  $SUDO sed -i 's|http://archive.ubuntu.com/ubuntu|https://ubuntu-archive-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list
  $SUDO sed -i 's|http://security.ubuntu.com/ubuntu|https://ubuntu-security-cache.local.gha-runners.nvidia.com/ubuntu|g' /etc/apt/sources.list
  $SUDO sed -i 's|http://ports.ubuntu.com/ubuntu-ports|https://ubuntu-ports-cache.local.gha-runners.nvidia.com/ubuntu-ports|g' /etc/apt/sources.list
else
  echo "No apt sources file found"
  exit 0
fi
