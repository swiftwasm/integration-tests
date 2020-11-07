#!/bin/bash

set -x
source_path="$(cd "$(dirname $0)" && pwd)"
work_dir="$(mktemp -d)"
(cd "$work_dir" && \
  $TOOLCHAIN/usr/bin/swiftc -target wasm32-wasi $source_path/main.swift -sdk $TOOLCHAIN/usr/share/wasi-sysroot -static-stdlib -o main.wasm && \
  $TOOLCHAIN/usr/bin/swiftc -target wasm32-wasi $source_path/main.swift -static-stdlib -o main.wasm && \
  $TOOLCHAIN/usr/bin/swiftc -target wasm32-wasi $source_path/main.swift -o main.wasm && \
  wasmer run main.wasm && \
  wasmtime run main.wasm
)
