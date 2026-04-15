#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/gifs"

mk() {
  local name="$1" fps="$2" colors="$3" width="$4" duration="$5" hue="$6"
  local height=$(( width * 630 / 1200 ))
  ffmpeg -y -hide_banner -loglevel error \
    -f lavfi -i "testsrc2=size=${width}x${height}:rate=${fps}:duration=${duration}" \
    -vf "hue=h=${hue},split[a][b];[a]palettegen=max_colors=${colors}[p];[b][p]paletteuse=dither=bayer:bayer_scale=5" \
    "${name}.gif"
}

#  tmp fps colors width dur hue   target ~MB
mk g 20  256 1200  8   20   # ~5
mk h 23  256 1200  9   80   # ~6
mk i 27  256 1200  9   150  # ~7
mk j 30  256 1200  9   210  # ~8

for f in g h i j; do
  bytes=$(wc -c < "${f}.gif" | tr -d ' ')
  mb=$(awk "BEGIN{printf \"%.1f\", $bytes/1048576}")
  newname="${mb}mb"
  if [ -e "${newname}.gif" ]; then newname="${newname}b"; fi
  mv "${f}.gif" "${newname}.gif"
  printf "%-12s %10d bytes\n" "${newname}.gif" "$bytes"
done
