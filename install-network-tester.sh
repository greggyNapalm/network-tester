#!/usr/bin/env bash
set -euo pipefail

# Install network-tester binary for the current platform.
#
# Usage:
#   curl -sSfL https://raw.githubusercontent.com/OWNER/REPO/main/scripts/install-network-tester.sh | bash
#   curl -sSfL ... | bash -s -- --version 1.2.0 --dir /usr/local/bin
#
# Options:
#   --version VERSION   Install a specific version (default: latest)
#   --dir DIR           Install directory (default: /usr/local/bin)
#   --repo OWNER/REPO   GitHub repo (default: greggyNapalm/network-tester)

INSTALL_DIR="/usr/local/bin"
VERSION="latest"
GITHUB_REPO="greggyNapalm/network-tester"

while [ $# -gt 0 ]; do
  case "$1" in
  --version)
    VERSION="$2"
    shift 2
    ;;
  --dir)
    INSTALL_DIR="$2"
    shift 2
    ;;
  --repo)
    GITHUB_REPO="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

detect_os() {
  local os
  os="$(uname -s)"
  case "$os" in
  Linux*) echo "linux" ;;
  Darwin*) echo "darwin" ;;
  FreeBSD*) echo "freebsd" ;;
  *)
    echo "Unsupported OS: $os" >&2
    exit 1
    ;;
  esac
}

detect_arch() {
  local arch
  arch="$(uname -m)"
  case "$arch" in
  x86_64 | amd64) echo "amd64" ;;
  aarch64 | arm64) echo "arm64" ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
  esac
}

OS="$(detect_os)"
ARCH="$(detect_arch)"

echo "Detected platform: ${OS}/${ARCH}"

# Resolve version
if [ "$VERSION" = "latest" ]; then
  VERSION="$(curl -sSfL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"tag_name":\s*"([^"]+)".*/\1/')"
  if [ -z "$VERSION" ]; then
    echo "Error: could not determine latest version." >&2
    exit 1
  fi
fi

# Strip leading 'v' for the archive name
VERSION_NUM="${VERSION#v}"

ARCHIVE="network-tester_${VERSION_NUM}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/${GITHUB_REPO}/releases/download/${VERSION}/${ARCHIVE}"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Downloading ${ARCHIVE}..."
curl -sSfL -o "${TMPDIR}/${ARCHIVE}" "$URL"

echo "Extracting..."
tar -xzf "${TMPDIR}/${ARCHIVE}" -C "$TMPDIR"

echo "Installing to ${INSTALL_DIR}/network-tester..."
if [ -w "$INSTALL_DIR" ]; then
  mv "${TMPDIR}/network-tester" "${INSTALL_DIR}/network-tester"
else
  sudo mv "${TMPDIR}/network-tester" "${INSTALL_DIR}/network-tester"
fi
chmod +x "${INSTALL_DIR}/network-tester"

echo "network-tester ${VERSION} installed successfully."
echo ""
network-tester --version 2>/dev/null || "${INSTALL_DIR}/network-tester" --version
