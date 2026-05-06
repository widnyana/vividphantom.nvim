---@class vividphantom.Palette
---@field bg? string
---@field bg_alt? string
---@field bg_highlight? string
---@field bg_solid? string
---@field fg? string
---@field grey? string
---@field blue? string
---@field green? string
---@field cyan? string
---@field red? string
---@field yellow? string
---@field magenta? string
---@field pink? string
---@field orange? string
---@field purple? string

---@class vividphantom.Colors
---@field tritan vividphantom.Palette
---@field protan vividphantom.Palette
---@field default vividphantom.Palette  -- alias for tritan, kept for compatibility
local M = {}

-- Tritan-safe palette (default).
-- Tuned for tritanopia / tritanomaly (blue-yellow CVD): the discriminating
-- pairs are red/green and magenta/cyan, since the blue-yellow axis collapses.
M.tritan = {
    bg = "#16181a",
    bg_alt = "#1e2124",
    bg_highlight = "#3c4048",
    fg = "#ffffff",
    grey = "#8b949e",
    blue = "#a78bfa",
    green = "#4ade80",
    cyan = "#5eead4",
    red = "#ff6e5e",
    yellow = "#fbbf24",
    magenta = "#ff5ef1",
    pink = "#ff5ea0",
    orange = "#fb923c",
    purple = "#e879f9",
}

-- Protan-safe palette.
-- Tuned for protanopia / protanomaly (red-green CVD, weak L cones):
--   * `red` is shifted toward magenta so it carries blue-channel signal
--     (avoids the dark-red-looks-black trap)
--   * `green` leans cool (toward cyan) so it doesn't collapse onto yellow
--   * `yellow` is a bright, pure yellow with high luminance
--   * `blue`/`cyan`/`purple`/`magenta` are perceived close to normal and
--     anchor most semantic roles
M.protan = {
    bg = "#16181a",
    bg_alt = "#1e2124",
    bg_highlight = "#3c4048",
    fg = "#ffffff",
    grey = "#8b949e",
    blue = "#82a8ff",
    green = "#7eef9c",
    cyan = "#5eead4",
    red = "#ff6b9d",
    yellow = "#ffd54a",
    magenta = "#ff5ef1",
    pink = "#ff8acc",
    orange = "#ff9e3d",
    purple = "#c084fc",
}

-- Back-compat alias. `colors.default` was the original public name before
-- variants were introduced; new code should prefer an explicit variant.
M.default = M.tritan

return M
