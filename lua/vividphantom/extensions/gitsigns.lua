local util = require("vividphantom.util")
local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        GitSignsAdd = { fg = t.green },
        GitSignsChange = { fg = t.orange },
        GitSignsDelete = { fg = t.red },
        GitSignsAddInline = { bg = util.blend(t.bg_solid, t.green, 0.9) },
        GitSignsChangeInline = { bg = util.blend(t.bg_solid, t.blue, 0.9) },
        GitSignsDeleteInline = { bg = util.blend(t.bg_solid, t.red, 0.9) },
    }
end

return M
