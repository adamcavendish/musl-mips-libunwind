#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}"
if [ ! -d libunwind ]; then
  git clone -b v1.7.2 https://github.com/libunwind/libunwind.git
  cd libunwind
  git am ../patch/*.patch
fi

cd "${SCRIPT_DIR}/libunwind"

export CC="${SCRIPT_DIR}/toolchains/mipsel-linux-musl-cross/bin/mipsel-linux-musl-gcc"
export CXX="${SCRIPT_DIR}/toolchains/mipsel-linux-musl-cross/bin/mipsel-linux-musl-g++"
export AR="${SCRIPT_DIR}/toolchains/mipsel-linux-musl-cross/bin/mipsel-linux-musl-ar"

declare -a FLAGS
# Configure
FLAGS+=("--disable-tests")
FLAGS+=("--enable-cxx-exceptions")
# Cross compile flags
FLAGS+=("--build=x86_64-linux-gnu")
FLAGS+=("--host=mipsel-linux-gnu")

autoreconf -i
./configure --prefix="${SCRIPT_DIR}/install" "${FLAGS[@]}"
make && make install
