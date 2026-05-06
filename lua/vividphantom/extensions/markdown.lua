local util = require("vividphantom.util")
local M = {}

--- Get extension configuration (render-markdown.nvim).
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    return {
        RenderMarkdownH1 = { fg = t.orange, bold = true },
        RenderMarkdownH2 = { fg = t.cyan, bold = true },
        RenderMarkdownH3 = { fg = t.blue, bold = true },
        RenderMarkdownH4 = { fg = t.purple, bold = true },
        RenderMarkdownH5 = { fg = t.magenta, bold = true },
        RenderMarkdownH6 = { fg = t.green, bold = true },
        RenderMarkdownH1Bg = { bg = util.blend(t.bg_solid, t.orange, 0.85) },
        RenderMarkdownH2Bg = { bg = util.blend(t.bg_solid, t.cyan, 0.85) },
        RenderMarkdownH3Bg = { bg = util.blend(t.bg_solid, t.blue, 0.85) },
        RenderMarkdownH4Bg = { bg = util.blend(t.bg_solid, t.purple, 0.85) },
        RenderMarkdownH5Bg = { bg = util.blend(t.bg_solid, t.magenta, 0.85) },
        RenderMarkdownH6Bg = { bg = util.blend(t.bg_solid, t.green, 0.85) },
        RenderMarkdownQuote = { fg = t.grey },
        RenderMarkdownCode = { bg = t.bg_alt },
        RenderMarkdownBullet = { fg = t.grey },
        RenderMarkdownDash = { fg = t.grey },
        RenderMarkdownTodo = { fg = t.orange },
        RenderMarkdownTableHead = { fg = t.grey },
        RenderMarkdownSuccess = { fg = t.green },
        RenderMarkdownInfo = { fg = t.blue },
        RenderMarkdownHint = { fg = t.cyan },
        RenderMarkdownWarn = { fg = t.orange },
        RenderMarkdownError = { fg = t.red },
    }
end

return M
