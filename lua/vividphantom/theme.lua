local colors = require("vividphantom.colors")

local M = {}

function M.setup()
    local config = require("vividphantom.config")
    local opts = config.options

    ---@type vividphantom.Palette
    local t = vim.deepcopy(colors.default)

    -- Apply user color overrides
    local color_overrides = opts.colors or {}
    t = vim.tbl_deep_extend("force", t, color_overrides)

    -- bg_solid is the actual background color, used for blends even when
    -- transparent rendering is enabled.
    t.bg_solid = t.bg
    if opts.transparent then
        t.bg = "NONE"
        t.bg_alt = "NONE"
    end

    if opts.hide_fillchars then
        vim.opt.fillchars:append({
            horiz = " ",
            horizup = " ",
            horizdown = " ",
            vert = " ",
            vertleft = " ",
            vertright = " ",
            verthoriz = " ",
            eob = " ",
        })
    end

    if opts.terminal_colors then
        vim.g.terminal_color_0 = t.bg
        vim.g.terminal_color_8 = t.bg_alt
        vim.g.terminal_color_7 = t.fg
        vim.g.terminal_color_15 = t.grey
        vim.g.terminal_color_1 = t.red
        vim.g.terminal_color_9 = t.red
        vim.g.terminal_color_2 = t.green
        vim.g.terminal_color_10 = t.green
        vim.g.terminal_color_3 = t.yellow
        vim.g.terminal_color_11 = t.yellow
        vim.g.terminal_color_4 = t.blue
        vim.g.terminal_color_12 = t.blue
        vim.g.terminal_color_5 = t.purple
        vim.g.terminal_color_13 = t.purple
        vim.g.terminal_color_6 = t.cyan
        vim.g.terminal_color_14 = t.cyan
    end

    local theme = {}
    theme.highlights = require("vividphantom.extensions.base").get(opts, t)

    for extension, enabled in pairs(opts.extensions or {}) do
        if enabled then
            local ok, ext = pcall(require, "vividphantom.extensions." .. extension)
            if ok then
                theme.highlights = vim.tbl_deep_extend("force", theme.highlights, ext.get(opts, t))
            end
        end
    end

    local overrides = opts.overrides or opts.highlights
    if type(overrides) == "function" then
        overrides = overrides(t)
    end
    theme.highlights = vim.tbl_extend("force", theme.highlights, overrides or {})

    return theme
end

return M
