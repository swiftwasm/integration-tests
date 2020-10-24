#!/bin/bash

BIN_PATH="$1"
export WASMTIME_HOME=$(mktemp -d)
curl https://wasmtime.dev/install.sh --fail --location | sh
mkdir -p "$BIN_PATH"
mv "$WASMTIME_HOME/bin/"* "$BIN_PATH/"
