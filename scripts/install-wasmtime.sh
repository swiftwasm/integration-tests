#!/bin/bash

export WASMTIME_HOME=$(dirname "$1")
curl https://wasmtime.dev/install.sh --fail --location | sh
