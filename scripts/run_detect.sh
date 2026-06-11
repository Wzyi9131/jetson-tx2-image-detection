#!/usr/bin/env bash
set -euo pipefail

JETSON_INFERENCE_DIR="${JETSON_INFERENCE_DIR:-$HOME/jetson-inference}"
INPUT_IMAGE="${1:-data/images/peds_0.jpg}"
OUTPUT_IMAGE="${2:-output.jpg}"
NETWORK="${NETWORK:-ssd-mobilenet-v2}"

cd "$JETSON_INFERENCE_DIR"

./build/aarch64/bin/detectnet --network="$NETWORK" "$INPUT_IMAGE" "$OUTPUT_IMAGE"
