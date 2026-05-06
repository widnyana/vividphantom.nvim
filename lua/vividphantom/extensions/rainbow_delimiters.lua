local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        RainbowDelimiterRed = { fg = t.red },
        RainbowDelimiterYellow = { fg = t.yellow },
        RainbowDelimiterBlue = { fg = t.blue },
        RainbowDelimiterOrange = { fg = t.orange },
        RainbowDelimiterGreen = { fg = t.green },
        RainbowDelimiterViolet = { fg = t.purple },
        RainbowDelimiterCyan = { fg = t.cyan },
    }
end

return M
