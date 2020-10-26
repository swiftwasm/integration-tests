#!/bin/bash

set -x
source_path="$(cd "$(dirname $0)" && pwd)"
work_dir="$(mktemp -d)"
(cd "$work_dir" && \
  $TOOLCHAIN/usr/bin/swift package init --name Example && \
  $TOOLCHAIN/usr/bin/swift build --triple wasm32-unknown-wasi -Xswiftc -static-stdlib && \
  $TOOLCHAIN/usr/bin/swift package clean && \
  $TOOLCHAIN/usr/bin/swift build --triple wasm32-unknown-wasi -Xswiftc -static-stdlib --build-tests
)
