local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        LazyH1 = { fg = t.blue, bold = true },
        LazyH2 = { fg = t.fg, bold = true },
        LazyButton = { fg = t.fg, bg = t.bg_highlight },
        LazyButtonActive = { fg = t.fg, bg = t.bg_highlight, bold = true },
        LazyProgressDone = { bold = true, fg = t.magenta },
        LazyProgressTodo = { bold = true, fg = t.grey },
        LazyReasonCmd = { fg = t.yellow },
        LazyReasonEvent = { fg = t.magenta },
        LazyReasonKeys = { fg = t.cyan },
        LazyReasonPlugin = { fg = t.green },
        LazyReasonRequire = { fg = t.orange },
        LazyReasonRuntime = { fg = t.red },
        LazyReasonStart = { fg = t.blue },
        LazySpecial = { fg = t.cyan },
    }
end

return M
