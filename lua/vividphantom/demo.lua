-- Open a scratch buffer that exercises every semantic palette role and the
-- highlight groups most likely to collide under CVD simulation. Intended for
-- visual inspection and screenshotting before/after palette changes.

local M = {}

local SECTIONS = {
    {
        title = "Diagnostics",
        rows = {
            { hl = "DiagnosticError", label = "error: undefined identifier" },
            { hl = "DiagnosticWarn", label = "warning: unused variable" },
            { hl = "DiagnosticInfo", label = "info: type inferred" },
            { hl = "DiagnosticHint", label = "hint: prefer const" },
        },
    },
    {
        title = "Diff / VCS",
        rows = {
            { hl = "DiffAdd", label = "+ added line" },
            { hl = "DiffChange", label = "~ changed line" },
            { hl = "DiffDelete", label = "- deleted line" },
            { hl = "DiffText", label = "~ inline change" },
            { hl = "Added", label = "Added (text-only)" },
            { hl = "Removed", label = "Removed (text-only)" },
            { hl = "GitSignsAdd", label = "+ gitsigns add" },
            { hl = "GitSignsChange", label = "~ gitsigns change" },
            { hl = "GitSignsDelete", label = "- gitsigns delete" },
        },
    },
    {
        title = "Syntax",
        rows = {
            { hl = "Comment", label = "-- a comment" },
            { hl = "Keyword", label = "if then else" },
            { hl = "Statement", label = "return break" },
            { hl = "String", label = '"a string"' },
            { hl = "Character", label = "'c'" },
            { hl = "Number", label = "42" },
            { hl = "Boolean", label = "true false" },
            { hl = "Function", label = "fn_name()" },
            { hl = "Type", label = "TypeName" },
            { hl = "Constant", label = "CONSTANT" },
            { hl = "Operator", label = "+ - * / =" },
            { hl = "PreProc", label = "#include" },
            { hl = "Special", label = "\\n \\t" },
            { hl = "Todo", label = "TODO marker" },
            { hl = "Error", label = "Error syntax group" },
        },
    },
    {
        title = "UI",
        rows = {
            { hl = "Search", label = "search match" },
            { hl = "IncSearch", label = "incsearch match" },
            { hl = "CurSearch", label = "current search" },
            { hl = "MatchParen", label = "matched ()" },
            { hl = "Visual", label = "visual selection" },
            { hl = "PmenuSel", label = "pmenu selected" },
            { hl = "WildMenu", label = "wildmenu" },
            { hl = "Substitute", label = "substitute target" },
        },
    },
}

local PALETTE_KEYS = {
    "red",
    "yellow",
    "green",
    "cyan",
    "blue",
    "magenta",
    "pink",
    "orange",
    "purple",
    "fg",
    "grey",
    "bg_solid",
    "bg_alt",
    "bg_highlight",
}

local NS = vim.api.nvim_create_namespace("vividphantom_demo")

--- Open the demo buffer in the current window.
function M.open()
    local config = require("vividphantom.config")
    local colors = require("vividphantom.colors")
    local opts = config.options
    local variant = opts.variant or "tritan"
    local palette = colors[variant] or colors.tritan

    local lines = {}
    local marks = {}

    local function push(text)
        table.insert(lines, text)
        return #lines - 1
    end

    local function highlight(line_idx, col_start, col_end, hl)
        table.insert(marks, { line = line_idx, col_start = col_start, col_end = col_end, hl = hl })
    end

    push(("vividphantom — variant = %s"):format(variant))
    push("")

    push("--- Palette ---")
    for _, key in ipairs(PALETTE_KEYS) do
        local color = palette[key]
        if color then
            local hl = "VividphantomDemoSwatch_" .. key
            vim.api.nvim_set_hl(0, hl, { fg = color })
            local prefix = ("%-15s %s  "):format(key, color)
            local swatch = "████████"
            local line = prefix .. swatch
            local idx = push(line)
            highlight(idx, #prefix, #line, hl)
        end
    end
    push("")

    for _, section in ipairs(SECTIONS) do
        push(("--- %s ---"):format(section.title))
        for _, row in ipairs(section.rows) do
            local prefix = ("%-26s "):format(row.hl)
            local line = prefix .. row.label
            local idx = push(line)
            highlight(idx, #prefix, #line, row.hl)
        end
        push("")
    end

    push("--- Bold / Italic / Underline ---")
    do
        local bold_idx = push("bold sample text")
        vim.api.nvim_set_hl(0, "VividphantomDemoBold", { fg = palette.fg, bold = true })
        highlight(bold_idx, 0, #"bold sample text", "VividphantomDemoBold")

        local italic_idx = push("italic sample text")
        vim.api.nvim_set_hl(0, "VividphantomDemoItalic", { fg = palette.fg, italic = true })
        highlight(italic_idx, 0, #"italic sample text", "VividphantomDemoItalic")

        local underline_idx = push("underline sample text")
        vim.api.nvim_set_hl(0, "VividphantomDemoUnderline", { fg = palette.fg, underline = true })
        highlight(underline_idx, 0, #"underline sample text", "VividphantomDemoUnderline")

        local undercurl_idx = push("undercurl error sample")
        vim.api.nvim_set_hl(0, "VividphantomDemoUndercurl", { sp = palette.red, undercurl = true })
        highlight(undercurl_idx, 0, #"undercurl error sample", "VividphantomDemoUndercurl")
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "vividphantom://demo")
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "vividphantom-demo"

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    for _, m in ipairs(marks) do
        vim.api.nvim_buf_set_extmark(buf, NS, m.line, m.col_start, {
            end_col = m.col_end,
            hl_group = m.hl,
        })
    end

    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true

    vim.api.nvim_set_current_buf(buf)
end

return M
