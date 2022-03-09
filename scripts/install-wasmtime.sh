#!/bin/bash

set -ue

BIN_PATH="$1"
export WASMTIME_HOME=$(mktemp -d)
curl https://wasmtime.dev/install.sh --fail --location | bash -s -- --version v0.35.1
mkdir -p "$BIN_PATH"
mv "$WASMTIME_HOME/bin/"* "$BIN_PATH/"
