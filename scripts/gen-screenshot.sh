#!/usr/bin/env bash
# Render a real PNG of :VividphantomDemo for a given variant and produce
# CVD-simulated copies via ImageMagick's color-matrix.
#
# Pipeline:
#   1. asciinema records nvim under a 120x80 PTY (--window-size), with the
#      demo buffer fully drawn before :qa fires
#   2. agg renders the asciicast to a multi-frame GIF
#   3. ImageMagick coalesces frames; we keep the middle frame (the rendered
#      demo, post-redraw, before exit-clear)
#   4. ImageMagick applies the Viénot/Brettel/Mollon 1999 RGB→RGB matrix per
#      sim type (protan / tritan / deutan) in linear-light, producing
#      "what a CVD reader would see" copies of the same TUI
#
# Outputs:
#   <out>/vividphantom-<variant>.png            — real nvim TUI render
#   <out>/vividphantom-<variant>-protan-sim.png
#   <out>/vividphantom-<variant>-tritan-sim.png
#   <out>/vividphantom-<variant>-deutan-sim.png
#
# Usage:
#   bash scripts/gen-screenshot.sh <variant> <out_dir>

set -euo pipefail
VARIANT=${1:-protan}
OUT=${2:-/tmp/vp-shots}
mkdir -p "$OUT"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CAST=$(mktemp --suffix=.cast)
GIF=$(mktemp --suffix=.gif)
FRAME_DIR=$(mktemp -d)
trap 'rm -rf "$CAST" "$GIF" "$FRAME_DIR"' EXIT

# --- Step 1: record the demo via headless asciinema PTY ---------------------
TERM=xterm-256color asciinema rec --window-size 120x80 \
    -c "nvim \
        --cmd 'set rtp+=$REPO_ROOT' \
        --cmd 'lua require(\"vividphantom\").setup({variant=\"$VARIANT\"})' \
        -c 'colorscheme vividphantom' \
        -c 'VividphantomDemo' \
        -c 'redraw' \
        -c 'sleep 1500m' \
        -c 'qa!'" \
    "$CAST" 2>&1 | grep -v '^:::' || true

# --- Step 2: render cast → GIF via agg --------------------------------------
agg --font-size 18 "$CAST" "$GIF" >/dev/null 2>&1

# --- Step 3: coalesce frames; pick the largest (== rendered demo) -----------
# agg's frame count varies (initial blank, redraw, post-exit blank). The
# rendered-demo frame is reliably the largest by byte size, while the
# blank/cleared frames are tiny. Sort by size, take the biggest.
magick "$GIF" -coalesce "$FRAME_DIR/frame-%d.png"

NORMAL_PNG="$OUT/vividphantom-$VARIANT.png"
biggest_frame=$(/usr/bin/ls -S "$FRAME_DIR"/frame-*.png | head -1)
cp "$biggest_frame" "$NORMAL_PNG"
echo "rendered: $NORMAL_PNG (from $biggest_frame, $(stat -c %s "$NORMAL_PNG") bytes)"

# --- Step 4: simulate via Viénot 1999 matrices in linear-light --------------
simulate() {
    local kind=$1 matrix=$2 out=$3
    magick "$NORMAL_PNG" \
        -colorspace RGB \
        -color-matrix "$matrix" \
        -colorspace sRGB \
        "$out"
    echo "simulated ($kind): $out"
}

simulate protan \
    "0.152286 1.052583 -0.204868 0.114503 0.786281 0.099216 -0.003882 -0.048116 1.051998" \
    "$OUT/vividphantom-$VARIANT-protan-sim.png"

simulate tritan \
    "1.255528 -0.076749 -0.178779 -0.078411 0.930809 0.147602 0.004733 0.691367 -0.696100" \
    "$OUT/vividphantom-$VARIANT-tritan-sim.png"

simulate deutan \
    "0.367322 0.860646 -0.227968 0.280085 0.672501 0.047413 -0.011820 0.042940 0.968881" \
    "$OUT/vividphantom-$VARIANT-deutan-sim.png"

echo "done. files in $OUT/"
ls -la "$OUT/vividphantom-$VARIANT"*.png
