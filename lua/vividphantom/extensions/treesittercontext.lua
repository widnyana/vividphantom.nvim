local util = require("vividphantom.util")
local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        TreesitterContext = { bg = util.blend(t.bg_solid, t.bg_highlight, 0.7) },
        TreesitterContextLineNumber = { fg = util.blend(t.grey, t.bg_highlight, 0.8) },
    }
end

return M
