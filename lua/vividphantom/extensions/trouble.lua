local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        TroubleCode = { fg = t.magenta },
        TroubleCount = { bg = t.bg_highlight, bold = true },
        TroubleDirectory = { fg = t.grey, bold = true },
        TroubleFilename = { fg = t.cyan },
        TroubleIconArray = { fg = t.pink },
        TroubleIconDirectory = { fg = t.blue },
    }
end

return M
