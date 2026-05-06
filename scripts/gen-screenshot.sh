#!/usr/bin/env bash
# Render a PNG that mirrors :VividphantomDemo for a given variant, then
# also produce a CVD-simulated copy via ImageMagick's color-matrix.
#
# Outputs:
#   <out>/vividphantom-<variant>.png            — normal rendering
#   <out>/vividphantom-<variant>-protan-sim.png — same image under protan sim
#   <out>/vividphantom-<variant>-tritan-sim.png — same image under tritan sim
#
# Usage:
#   bash scripts/gen-screenshot.sh <variant> <out_dir>

set -euo pipefail
VARIANT=${1:-protan}
OUT=${2:-/tmp/vp-shots}
mkdir -p "$OUT"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PALETTE_FILE=$(mktemp)
GROUPS_FILE=$(mktemp)
trap 'rm -f "$PALETTE_FILE" "$GROUPS_FILE"' EXIT

# --- Step 1: resolve palette + highlight groups via headless nvim ---------
nvim --headless --clean -u NONE \
  --cmd "set rtp+=$REPO_ROOT" \
  --cmd "lua
require('vividphantom').setup({ variant = '$VARIANT', transparent = false })
vim.cmd.colorscheme('vividphantom')

local palette = require('vividphantom.colors')['$VARIANT']
local order = { 'red','yellow','green','cyan','blue','magenta','pink','orange','purple','grey','fg','bg_solid','bg_alt','bg_highlight' }
local f = io.open('$PALETTE_FILE', 'w')
for _, k in ipairs(order) do
    if palette[k] then f:write(k, ' ', palette[k], '\n') end
end
f:close()

local groups = {
    'DiagnosticError','DiagnosticWarn','DiagnosticInfo','DiagnosticHint',
    'DiffAdd','DiffChange','DiffDelete','DiffText',
    'Comment','Keyword','Statement','String','Number','Function','Type','Constant','Operator','Special',
    'Search','IncSearch','Visual','PmenuSel','MatchParen',
}
local g = io.open('$GROUPS_FILE', 'w')
for _, name in ipairs(groups) do
    local h = vim.api.nvim_get_hl(0, { name = name })
    g:write(string.format('%s %s %s %s %s\n',
        name,
        h.fg and string.format('#%06x', h.fg) or 'NONE',
        h.bg and string.format('#%06x', h.bg) or 'NONE',
        h.bold and 'bold' or '-',
        h.italic and 'italic' or '-'))
end
g:close()
" -c 'qa!' 2>/dev/null

# --- Step 2: build MVG draw commands --------------------------------------
W=1100
H=1100
BG="#16181a"
FG_DEFAULT="#ffffff"
GREY="#8b949e"
FONT="JetBrains-Mono"
FONT_SIZE=18
LINE_H=28
SECTION_GAP=18

DRAW=$(mktemp)
trap 'rm -f "$PALETTE_FILE" "$GROUPS_FILE" "$DRAW"' EXIT

draw_text() {
    local x=$1 y=$2 fill=$3 text=$4
    printf "fill '%s'\ntext %d,%d '%s'\n" "$fill" "$x" "$y" "$text" >> "$DRAW"
}

draw_rect() {
    local x1=$1 y1=$2 x2=$3 y2=$4 fill=$5
    printf "fill '%s'\nrectangle %d,%d %d,%d\n" "$fill" "$x1" "$y1" "$x2" "$y2" >> "$DRAW"
}

# Header
y=30
draw_text 30 $y "$FG_DEFAULT" "vividphantom — variant = $VARIANT"
y=$((y + LINE_H + SECTION_GAP))

# Palette section
draw_text 30 $y "$GREY" "── palette ──"
y=$((y + LINE_H))

PALETTE_X=30
SWATCH_W=110
LABEL_X=$((PALETTE_X + SWATCH_W + 16))
while read -r name color; do
    [ -z "$name" ] && continue
    draw_rect $PALETTE_X $((y - 18)) $((PALETTE_X + SWATCH_W)) $((y + 4)) "$color"
    draw_text $LABEL_X $y "$FG_DEFAULT" "$(printf '%-15s %s' "$name" "$color")"
    y=$((y + LINE_H))
done < "$PALETTE_FILE"
y=$((y + SECTION_GAP))

# Highlight-group sections
emit_group_row() {
    local group_name=$1 fg=$2 bg=$3 bold=$4 italic=$5 sample=$6
    local label
    label=$(printf '%-26s %s' "$group_name" "$sample")
    if [ "$bg" != "NONE" ]; then
        draw_rect 30 $((y - 18)) $((W - 30)) $((y + 4)) "$bg"
    fi
    local text_color="$fg"
    if [ "$fg" = "NONE" ]; then text_color="$FG_DEFAULT"; fi
    draw_text 30 $y "$text_color" "$label"
    y=$((y + LINE_H))
}

# samples per group
declare -A SAMPLES=(
    [DiagnosticError]="error: undefined identifier"
    [DiagnosticWarn]="warning: unused variable"
    [DiagnosticInfo]="info: type inferred"
    [DiagnosticHint]="hint: prefer const"
    [DiffAdd]="+ added line"
    [DiffChange]="~ changed line"
    [DiffDelete]="- deleted line"
    [DiffText]="~ inline change"
    [Comment]="-- a comment"
    [Keyword]="if then else"
    [Statement]="return break"
    [String]='"a string"'
    [Number]="42"
    [Function]="fn_name()"
    [Type]="TypeName"
    [Constant]="CONSTANT"
    [Operator]="+ - * / ="
    [Special]="\\\\n \\\\t"
    [Search]="search match"
    [IncSearch]="incsearch match"
    [Visual]="visual selection"
    [PmenuSel]="pmenu selected"
    [MatchParen]="matched ()"
)

emit_section() {
    local title=$1; shift
    draw_text 30 $y "$GREY" "── $title ──"
    y=$((y + LINE_H))
    for g in "$@"; do
        local row
        row=$(grep -E "^$g " "$GROUPS_FILE" || true)
        [ -z "$row" ] && continue
        # parse: name fg bg bold italic
        read -r _ fg bg bold italic <<< "$row"
        emit_group_row "$g" "$fg" "$bg" "$bold" "$italic" "${SAMPLES[$g]:-(no sample)}"
    done
    y=$((y + SECTION_GAP))
}

emit_section "diagnostics" DiagnosticError DiagnosticWarn DiagnosticInfo DiagnosticHint
emit_section "diff" DiffAdd DiffChange DiffDelete DiffText
emit_section "syntax" Comment Keyword Statement String Number Function Type Constant Operator Special
emit_section "ui" Search IncSearch Visual PmenuSel MatchParen

# --- Step 3: render PNG ---------------------------------------------------
NORMAL_PNG="$OUT/vividphantom-$VARIANT.png"
magick -size "${W}x${H}" "xc:$BG" \
    -font "$FONT" -pointsize "$FONT_SIZE" \
    -draw "@$DRAW" \
    "$NORMAL_PNG"
echo "rendered: $NORMAL_PNG"

# --- Step 4: simulated versions via Viénot 1999 RGB→RGB matrices -----------
# Note: ImageMagick applies -color-matrix in linear-light when colorspace is set
# to RGB beforehand and back to sRGB after.

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
ls -la "$OUT/"
