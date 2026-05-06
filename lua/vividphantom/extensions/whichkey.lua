local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        WhichKey = { fg = t.cyan },
        WhichKeyGroup = { fg = t.blue },
        WhichKeyDesc = { fg = t.pink },
        WhichKeySeperator = { fg = t.grey },
        WhichKeyFloat = { bg = t.bg },
        WhichKeyValue = { fg = t.blue },
        WhichKeyIcon = { fg = t.blue },
        WhichKeyIconBlue = { fg = t.blue },
        WhichKeyIconCyan = { fg = t.cyan },
        WhichKeyIconGreen = { fg = t.green },
        WhichKeyIconGrey = { fg = t.grey },
        WhichKeyIconOrange = { fg = t.orange },
        WhichKeyIconPurple = { fg = t.purple },
        WhichKeyIconRed = { fg = t.red },
        WhichKeyIconYellow = { fg = t.yellow },
    }
end

return M
