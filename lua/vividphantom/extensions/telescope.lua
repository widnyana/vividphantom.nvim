local M = {}

--- Get extension configuration
--- @param opts vividphantom.Config
--- @param t vividphantom.Palette
function M.get(opts, t)
    opts = opts or {}
    local highlights = {
        TelescopePreviewTitle = { fg = t.bg_alt, bg = t.green, bold = true },
        TelescopePromptPrefix = { fg = t.blue, bg = t.bg_alt },
        TelescopePromptCounter = { fg = t.cyan, bg = t.bg_alt },
        TelescopePromptTitle = { fg = t.bg_alt, bg = t.blue, bold = true },
        TelescopeResultsTitle = { fg = t.blue, bg = t.bg_alt, bold = true },
        TelescopeSelection = { bg = t.bg_highlight },
        TelescopeMatching = { fg = t.cyan },
    }

    if opts.borderless_pickers then
        highlights.TelescopeBorder = { fg = t.bg_alt, bg = t.bg_alt }
        highlights.TelescopeNormal = { bg = t.bg_alt }
        highlights.TelescopePreviewBorder = { fg = t.bg_alt, bg = t.bg_alt }
        highlights.TelescopePreviewNormal = { bg = t.bg_alt }
        highlights.TelescopeResultsBorder = { fg = t.bg_alt, bg = t.bg_alt }
        highlights.TelescopeResultsNormal = { bg = t.bg_alt }
    end

    return highlights
end

return M
