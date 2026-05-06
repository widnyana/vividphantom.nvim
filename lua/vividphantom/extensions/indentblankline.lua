local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        IblIndent = { fg = t.bg_highlight },
        IblScope = { fg = t.grey },
    }
end

return M
