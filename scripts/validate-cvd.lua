-- Validate that semantic-role color pairs remain distinguishable for the
-- target audience of each variant (tritan palette under tritan simulation,
-- protan palette under protan simulation).
--
-- Method:
--   1. Linearize sRGB (gamma 2.4 with the standard sRGB knee).
--   2. Apply a Viénot/Brettel/Mollon (1999) RGB→RGB dichromat projection.
--   3. Convert to CIE Lab and compute ΔE76 (Euclidean distance in Lab).
--   4. Compare each role pair against a "clearly distinguishable" threshold.
--
-- ΔE76 thresholds (rough, terminal-display context):
--   < 2.3  just-noticeable difference
--   2.3-10 noticeable on inspection
--   ≥ 10   clearly distinct       ← our pass bar
--
-- Run from the repo root:
--   nvim --headless --clean -u NONE \
--     --cmd 'set rtp+=.' \
--     -c 'luafile scripts/validate-cvd.lua' -c 'qa!'

local PASS_THRESHOLD = 10

-- sRGB ⇄ linear RGB --------------------------------------------------------

local function srgb_to_linear(c)
    c = c / 255
    if c <= 0.04045 then
        return c / 12.92
    end
    return ((c + 0.055) / 1.055) ^ 2.4
end

local function linear_to_srgb(c)
    c = math.max(0, math.min(1, c))
    if c <= 0.0031308 then
        return 12.92 * c * 255
    end
    return (1.055 * c ^ (1 / 2.4) - 0.055) * 255
end

local function hex_to_rgb(hex)
    return {
        tonumber(hex:sub(2, 3), 16),
        tonumber(hex:sub(4, 5), 16),
        tonumber(hex:sub(6, 7), 16),
    }
end

-- Dichromat simulation matrices (Viénot, Brettel & Mollon 1999) ------------
-- Operate on linear-RGB, output linear-RGB.

local SIM = {
    protan = {
        { 0.152286, 1.052583, -0.204868 },
        { 0.114503, 0.786281, 0.099216 },
        { -0.003882, -0.048116, 1.051998 },
    },
    deutan = {
        { 0.367322, 0.860646, -0.227968 },
        { 0.280085, 0.672501, 0.047413 },
        { -0.011820, 0.042940, 0.968881 },
    },
    tritan = {
        { 1.255528, -0.076749, -0.178779 },
        { -0.078411, 0.930809, 0.147602 },
        { 0.004733, 0.691367, -0.696100 },
    },
}

local function simulate(rgb, kind)
    local m = SIM[kind]
    if not m then
        return rgb
    end
    local r = srgb_to_linear(rgb[1])
    local g = srgb_to_linear(rgb[2])
    local b = srgb_to_linear(rgb[3])
    local nr = m[1][1] * r + m[1][2] * g + m[1][3] * b
    local ng = m[2][1] * r + m[2][2] * g + m[2][3] * b
    local nb = m[3][1] * r + m[3][2] * g + m[3][3] * b
    return { linear_to_srgb(nr), linear_to_srgb(ng), linear_to_srgb(nb) }
end

-- Lab conversion (D65) -----------------------------------------------------

local function rgb_to_xyz(rgb)
    local r = srgb_to_linear(rgb[1])
    local g = srgb_to_linear(rgb[2])
    local b = srgb_to_linear(rgb[3])
    return {
        (r * 0.4124 + g * 0.3576 + b * 0.1805) * 100,
        (r * 0.2126 + g * 0.7152 + b * 0.0722) * 100,
        (r * 0.0193 + g * 0.1192 + b * 0.9505) * 100,
    }
end

local function xyz_to_lab(xyz)
    local Xn, Yn, Zn = 95.047, 100.0, 108.883
    local function f(t)
        if t > 0.008856 then
            return t ^ (1 / 3)
        end
        return 7.787 * t + 16 / 116
    end
    local fx = f(xyz[1] / Xn)
    local fy = f(xyz[2] / Yn)
    local fz = f(xyz[3] / Zn)
    return { 116 * fy - 16, 500 * (fx - fy), 200 * (fy - fz) }
end

local function delta_e76(a, b)
    return math.sqrt((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2 + (a[3] - b[3]) ^ 2)
end

local function lab_under_sim(hex, sim_kind)
    local rgb = hex_to_rgb(hex)
    if sim_kind then
        rgb = simulate(rgb, sim_kind)
    end
    return xyz_to_lab(rgb_to_xyz(rgb))
end

-- Pairs to check -----------------------------------------------------------
-- Each entry: { palette_field_a, palette_field_b, "human-readable role pair" }
-- Diagnostic / severity pairs are checked first because they're highest stakes.

local SEVERITY_PAIRS = {
    { "red", "yellow", "Error vs Warning" },
    { "red", "green", "Error vs Success" },
    { "red", "blue", "Error vs Info" },
    { "red", "cyan", "Error vs Hint" },
    { "yellow", "green", "Warning vs Success" },
    { "yellow", "blue", "Warning vs Info" },
    { "yellow", "cyan", "Warning vs Hint" },
    { "green", "blue", "Success vs Info" },
    { "green", "cyan", "Success vs Hint" },
    { "blue", "cyan", "Info vs Hint" },
}

local SYNTAX_PAIRS = {
    { "orange", "yellow", "Keyword vs Number/Warning" },
    { "orange", "green", "Keyword vs String" },
    { "orange", "red", "Keyword vs Error" },
    { "red", "pink", "Error vs Constant" },
    { "red", "magenta", "Error vs Statement" },
    { "pink", "magenta", "Constant vs Statement" },
    { "purple", "magenta", "Type vs Statement" },
    { "purple", "blue", "Type vs Function" },
    { "purple", "pink", "Type vs Constant" },
    { "blue", "magenta", "Function vs Statement" },
    { "green", "cyan", "String vs Boolean/Hint" },
}

local function check(name, palette, sim_kind, pairs)
    print(string.format("=== %s under %s simulation ===", name, sim_kind or "no"))
    local fails = 0
    for _, pair in ipairs(pairs) do
        local a, b, label = pair[1], pair[2], pair[3]
        if palette[a] and palette[b] then
            local de = delta_e76(lab_under_sim(palette[a], sim_kind), lab_under_sim(palette[b], sim_kind))
            local mark = de >= PASS_THRESHOLD and "PASS" or "FAIL"
            if de < PASS_THRESHOLD then
                fails = fails + 1
            end
            print(string.format("  %-32s ΔE=%6.2f  %s", label, de, mark))
        end
    end
    return fails
end

-- Run ----------------------------------------------------------------------

local colors = require("vividphantom.colors")

local total_fails = 0

print()
print(string.format("threshold: ΔE76 ≥ %d (clearly distinct)", PASS_THRESHOLD))

print("\n## Severity pairs (must hold)")
total_fails = total_fails + check("protan palette", colors.protan, "protan", SEVERITY_PAIRS)
print()
total_fails = total_fails + check("tritan palette", colors.tritan, "tritan", SEVERITY_PAIRS)

print("\n## Syntax pairs (should hold)")
total_fails = total_fails + check("protan palette", colors.protan, "protan", SYNTAX_PAIRS)
print()
total_fails = total_fails + check("tritan palette", colors.tritan, "tritan", SYNTAX_PAIRS)

print("\n## Cross-check: how the protan palette holds up under deuteran sim")
total_fails = total_fails + check("protan palette", colors.protan, "deutan", SEVERITY_PAIRS)

print()
if total_fails == 0 then
    print(string.format("ALL PASS (threshold ΔE76 ≥ %d)", PASS_THRESHOLD))
else
    print(string.format("%d pair(s) below threshold — see FAIL rows above", total_fails))
end
