#!/bin/bash

BIN_PATH="$1"
export WASMER_DIR=$(mktemp -d)
curl https://get.wasmer.io --fail --location | sh
mkdir -p "$BIN_PATH"
mv "$WASMER_DIR/bin/"* "$BIN_PATH/"
