#!/usr/bin/env bash
set -euo pipefail

INPUT="${1:-source.mp4}"

ffprobe -v error \
  -select_streams v:0 \
  -show_entries stream=width,height,r_frame_rate,avg_frame_rate,duration,nb_frames \
  -of default=noprint_wrappers=1 \
  "$INPUT"
