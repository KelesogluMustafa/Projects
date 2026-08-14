#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-source.mp4}"
OUTPUT_DIR="${2:-frames}"

mkdir -p "$OUTPUT_DIR"

ffmpeg -y -i "$INPUT" \
  -vf "fps=8,scale=1280:-1" \
  -c:v libwebp \
  -lossless 0 \
  -compression_level 4 \
  -qscale 70 \
  -an \
  "$OUTPUT_DIR/taxi-%03d.webp"

echo "Frame extraction complete: $OUTPUT_DIR"
