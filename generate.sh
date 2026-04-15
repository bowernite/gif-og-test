#!/usr/bin/env bash
# Generate a ladder of GIFs at varying sizes for og:image platform testing.
# After generation, files are renamed by actual size (rounded) so URLs reflect truth.
set -euo pipefail
cd "$(dirname "$0")/gifs"
rm -f *.gif

gen() {
  local name="$1" fps="$2" colors="$3" width="$4" duration="$5" hue="$6"
  local height=$(( width * 630 / 1200 ))
  ffmpeg -y -hide_banner -loglevel error \
    -f lavfi -i "testsrc2=size=${width}x${height}:rate=${fps}:duration=${duration}" \
    -vf "hue=h=${hue},split[a][b];[a]palettegen=max_colors=${colors}[p];[b][p]paletteuse=dither=bayer:bayer_scale=5" \
    "${name}.gif"
}

# Tuned for this ffmpeg build to roughly span 100KB..8MB
#   name fps colors width dur hue
gen "a"  2   64    700   5   0
gen "b"  4   128   900   5   60
gen "c"  6   256   1100  5   120
gen "d"  10  256   1200  6   180
gen "e"  18  256   1200  7   240
gen "f"  30  256   1200  10  300

for f in a b c d e f; do
  bytes=$(wc -c < "${f}.gif" | tr -d ' ')
  kb=$(( (bytes + 512) / 1024 ))
  if [ "$kb" -ge 1024 ]; then
    mb=$(awk "BEGIN{printf \"%.1f\", $bytes/1048576}")
    newname="${mb}mb"
  else
    newname="${kb}kb"
  fi
  mv "${f}.gif" "${newname}.gif"
  printf "%-12s %10d bytes\n" "${newname}.gif" "$bytes"
done
