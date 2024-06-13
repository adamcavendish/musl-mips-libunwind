#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${SCRIPT_DIR}" && mkdir -p toolchains && cd toolchains

if [ -e mipsel-linux-musl-cross/bin/mipsel-linux-musl-gcc ]; then
  echo "Toolchains already installed."
  exit 0
fi

echo "Starting download toolchains."

wget -c https://musl.cc/mipsel-linux-musl-cross.tgz
tar xzf mipsel-linux-musl-cross.tgz

echo "Toolchains installed."

