local util = require("vividphantom.util")
local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        MiniClueNextKey = { fg = t.green },
        MiniDepsChangeAdded = { fg = t.green },
        MiniDepsChangeRemoved = { fg = t.red },
        MiniDiffOverAdd = { bg = util.blend(t.bg_solid, t.green, 0.8) },
        MiniDiffOverChange = { bg = util.blend(t.bg_solid, t.blue, 0.8) },
        MiniDiffOverContext = { bg = util.blend(t.bg_solid, t.orange, 0.8) },
        MiniDiffOverDelete = { bg = util.blend(t.bg_solid, t.red, 0.8) },
        MiniDiffSignAdd = { fg = t.green },
        MiniDiffSignChange = { fg = t.orange },
        MiniDiffSignDelete = { fg = t.red },
        MiniFilesBorder = { fg = t.bg_highlight },
        MiniFilesBorderModified = { fg = t.pink },
        MiniFilesDirectory = { fg = t.blue },
        MiniFilesTitle = { fg = util.blend(t.bg_highlight, t.cyan, 0.7) },
        MiniFilesTitleFocused = { fg = t.cyan },
        MiniHipatternsFixme = { fg = t.bg_solid, bg = t.red, bold = true },
        MiniHipatternsHack = { fg = t.bg_solid, bg = t.yellow, bold = true },
        MiniHipatternsNote = { fg = t.bg_solid, bg = t.blue, bold = true },
        MiniHipatternsTodo = { fg = t.bg_solid, bg = t.cyan, bold = true },
        MiniIconsBlue = { fg = t.blue },
        MiniIconsCyan = { fg = t.cyan },
        MiniIconsGreen = { fg = t.green },
        MiniIconsOrange = { fg = t.orange },
        MiniIconsPurple = { fg = t.purple },
        MiniIconsRed = { fg = t.red },
        MiniIconsYellow = { fg = t.yellow },
        MiniIndentscopeSymbol = { fg = t.grey },
        MiniJump2dDim = { fg = t.grey },
        MiniJump2dSpot = { fg = t.orange, bold = true, nocombine = true },
        MiniJump2dSpotAhead = { fg = t.cyan, bg = t.bg, nocombine = true },
        MiniJump2dSpotUnique = { fg = t.yellow, bold = true, nocombine = true },
        MiniPickMatchMarked = { bg = t.bg_highlight },
        MiniPickMatchRanges = { fg = t.orange },
        MiniStarterHeader = { fg = t.cyan },
        MiniStarterSection = { fg = t.blue },
        MiniStatuslineModeCommand = { fg = t.bg_solid, bg = t.yellow, bold = true },
        MiniStatuslineModeInsert = { fg = t.bg_solid, bg = t.green, bold = true },
        MiniStatuslineModeNormal = { fg = t.bg_solid, bg = t.blue, bold = true },
        MiniStatuslineModeOther = { fg = t.bg_solid, bg = t.cyan, bold = true },
        MiniStatuslineModeReplace = { fg = t.bg_solid, bg = t.red, bold = true },
        MiniStatuslineModeVisual = { fg = t.bg_solid, bg = t.magenta, bold = true },
        MiniTablineCurrent = { fg = t.fg, bg = t.bg_highlight, bold = true },
        MiniTablineHidden = { fg = t.grey, bg = t.bg },
        MiniTablineVisible = { fg = t.fg, bg = t.bg_highlight },
        MiniTestFail = { fg = t.red, bold = true },
        MiniTestPass = { fg = t.green, bold = true },
        MiniTrailspace = { bg = t.red },
    }
end

return M
