local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        NoiceFormatProgressDone = { fg = t.bg_solid, bg = t.cyan },
        NoiceFormatProgressTodo = { fg = t.grey, bg = t.bg_highlight },
        NoiceLspProgressClient = { fg = t.blue },
        NoiceLspProgressSpinner = { fg = t.orange },
        NoiceLspProgressTitle = { fg = t.cyan },
    }
end

return M
