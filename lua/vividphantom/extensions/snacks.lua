local util = require("vividphantom.util")
local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    local highlights = {
        SnacksNotifierIconError = { fg = t.red },
        SnacksNotifierTitleError = { fg = t.red },
        SnacksNotifierIconInfo = { fg = t.blue },
        SnacksNotifierTitleInfo = { fg = t.blue },
        SnacksNotifierIconTrace = { fg = t.purple },
        SnacksNotifierTitleTrace = { fg = t.purple },
        SnacksNotifierIconWarn = { fg = t.yellow },
        SnacksNotifierTitleWarn = { fg = t.yellow },
        SnacksNotifierBorderDebug = { fg = t.bg_highlight },
        SnacksDashboardDesc = { fg = t.cyan },
        SnacksDashboardFile = { fg = t.cyan },
        SnacksDashboardDir = { fg = t.grey },
        SnacksDashboardHeader = { fg = util.blend(t.purple, t.fg, 0.3) },
        SnacksDashboardIcon = { fg = t.blue },
        SnacksDashboardKey = { fg = t.orange },
        SnacksPickerMatch = { fg = t.cyan },
        SnacksPickerTotals = { fg = t.cyan, bold = true },
        SnacksPickerPrompt = { fg = t.blue, bold = true },
        SnacksPickerBoxTitle = { fg = t.bg_solid, bg = t.blue },
        SnacksPickerPreviewTitle = { fg = t.bg_solid, bg = t.green },
        SnacksPickerListTitle = { fg = t.bg_solid, bg = t.magenta },
        SnacksPickerInputTitle = { fg = t.bg_solid, bg = t.cyan },
    }

    if opts.borderless_pickers then
        highlights.SnacksPickerBorder = { fg = t.bg_alt, bg = t.bg_alt }
        highlights.SnacksPickerNormal = { bg = t.bg_alt }
        highlights.SnacksPickerBox = { bg = t.bg_alt }
        highlights.SnacksPickerList = { bg = t.bg_alt }
        highlights.SnacksPickerInput = { bg = t.bg_alt }
        highlights.SnacksPickerPreview = { bg = t.bg_alt }
    end

    return highlights
end

return M
