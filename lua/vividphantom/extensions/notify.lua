local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        NotifyERRORIcon = { fg = t.red },
        NotifyERRORTitle = { fg = t.pink },
        NotifyERRORBorder = { fg = t.bg_highlight },
        NotifyERRORBody = { fg = t.fg },
        NotifyINFOIcon = { fg = t.green },
        NotifyINFOTitle = { fg = t.cyan },
        NotifyINFOBorder = { fg = t.bg_highlight },
        NotifyINFOBody = { fg = t.fg },
        NotifyWARNIcon = { fg = t.orange },
        NotifyWARNTitle = { fg = t.yellow },
        NotifyWARNBorder = { fg = t.bg_highlight },
        NotifyWARNBody = { fg = t.fg },
        NotifyTRACEIcon = { fg = t.purple },
        NotifyTRACETitle = { fg = t.magenta },
        NotifyTRACEBorder = { fg = t.bg_highlight },
        NotifyDEBUGIcon = { fg = t.grey },
        NotifyDEBUGTitle = { fg = t.grey },
        NotifyDEBUGBorder = { fg = t.bg_highlight },
        NotifyDEBUGBody = { fg = t.fg },
        NotifyBackground = { bg = "NONE" },
    }
end

return M
