#!/bin/bash

export WASMER_DIR=$(dirname "$1")
curl https://get.wasmer.io --fail --location | sh
