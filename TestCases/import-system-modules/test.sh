#!/bin/bash

set -x
source_path="$(cd "$(dirname $0)" && pwd)"
work_dir="$(mktemp -d)"
# FIXME: The current SDK layout is wrong, so -resource-dir is necessary here. Swift SDK should be overlayed on wasi-sysroot.
(cd "$work_dir" && \
  $TOOLCHAIN/usr/bin/swiftc -resource-dir $TOOLCHAIN/usr/lib/swift_static -target wasm32-wasi $source_path/main.swift -sdk $TOOLCHAIN/usr/share/wasi-sysroot -static-stdlib -o main.wasm && \
  $TOOLCHAIN/usr/bin/swiftc -resource-dir $TOOLCHAIN/usr/lib/swift_static -target wasm32-wasi $source_path/main.swift -static-stdlib -o main.wasm && \
  $TOOLCHAIN/usr/bin/swiftc -resource-dir $TOOLCHAIN/usr/lib/swift_static -target wasm32-wasi $source_path/main.swift -o main.wasm && \
  wasmer run main.wasm && \
  # FIXME: enable wasmtime test after it supports Apple Silicon
  if [ $(uname -m) != "arm64" ]; then wasmtime run main.wasm; fi
)
