#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PROFILE="${1-debug}"

echo "Installing install/lib/libunwind.a -> toolchains/mipsel-linux-musl-cross-extra/libunwind.a"
cd "${SCRIPT_DIR}"
mkdir -p "toolchains/mipsel-linux-musl-cross-extra/"
install -m 0644 "install/lib/libunwind.a" "toolchains/mipsel-linux-musl-cross-extra/"

echo "Build profile: ${PROFILE}"
cd "${SCRIPT_DIR}/rust-mips-sample/"

TOOLCHAIN_DIR="${SCRIPT_DIR}/toolchains/mipsel-linux-musl-cross"

if [ "${PROFILE}" = "release" ]; then
  # Build release version with minimum size
  TARGET_CC="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-gcc"  \
  TARGET_CXX="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-g++" \
  TARGET_AR="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-ar"   \
    cargo build -Z build-std=std,panic_abort --target=mipsel-unknown-linux-musl --release
  exit 0
fi

# Build debug version
TARGET_CC="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-gcc"  \
TARGET_CXX="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-g++" \
TARGET_AR="${TOOLCHAIN_DIR}/bin/mipsel-linux-musl-ar"   \
  cargo build -Z build-std=std --target=mipsel-unknown-linux-musl
