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
---@field default vividphantom.Palette
local M = {}

M.default = {
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

return M
