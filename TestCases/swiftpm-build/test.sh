#!/bin/bash

set -x
source_path="$(cd "$(dirname $0)" && pwd)"
work_dir="$(mktemp -d)"
(cd "$work_dir" && \
  $TOOLCHAIN/usr/bin/swift package init --name Example && \
  cp "$source_path/../import-system-modules/main.swift" Sources/Example/Imports.swift && \
  $TOOLCHAIN/usr/bin/swift build --triple wasm32-unknown-wasi -Xswiftc -static-stdlib -Xswiftc -resource-dir -Xswiftc $TOOLCHAIN/usr/lib/swift_static && \
  $TOOLCHAIN/usr/bin/swift package clean && \
  echo "Skipping building tests. See https://github.com/swiftwasm/swift/issues/5551"
  # $TOOLCHAIN/usr/bin/swift build --triple wasm32-unknown-wasi -Xswiftc -static-stdlib -Xswiftc -resource-dir -Xswiftc $TOOLCHAIN/usr/lib/swift_static --build-tests && \
  # $TOOLCHAIN/usr/bin/swift package clean && \
  # $TOOLCHAIN/usr/bin/swift build --triple wasm32-unknown-wasi --build-tests -Xswiftc -resource-dir -Xswiftc $TOOLCHAIN/usr/lib/swift_static
)
