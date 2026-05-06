local M = {}

---@class vividphantom.Highlight
---@field fg? string
---@field bg? string
---@field sp? string
---@field bold? boolean
---@field italic? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field strikethrough? boolean
---@field nocombine? boolean
---@field link? string

---@alias vividphantom.OverrideFn fun(palette: vividphantom.Palette): table<string, vividphantom.Highlight>

---@class vividphantom.Extensions
---@field default? boolean Set all extensions to this value before user-specified overrides apply.
---@field blinkcmp? boolean
---@field cmp? boolean
---@field gitsigns? boolean
---@field indentblankline? boolean
---@field lazy? boolean
---@field markdown? boolean
---@field mini? boolean
---@field noice? boolean
---@field notify? boolean
---@field rainbow_delimiters? boolean
---@field snacks? boolean
---@field telescope? boolean
---@field treesitter? boolean
---@field treesittercontext? boolean
---@field trouble? boolean
---@field whichkey? boolean

---@alias vividphantom.LogLevel "off" | "error" | "warn" | "info" | "debug" | "trace"
---@alias vividphantom.Variant "tritan" | "protan"
---@alias vividphantom.DiffEmphasis "subtle" | "high"

---@class vividphantom.Config
---@field variant? vividphantom.Variant
---@field transparent? boolean
---@field italic_comments? boolean
---@field hide_fillchars? boolean
---@field terminal_colors? boolean
---@field borderless_pickers? boolean
---@field diff_emphasis? vividphantom.DiffEmphasis
---@field log_level? vividphantom.LogLevel
---@field colors? vividphantom.Palette
---@field highlights? table<string, vividphantom.Highlight> | vividphantom.OverrideFn
---@field overrides? vividphantom.OverrideFn
---@field extensions? vividphantom.Extensions
local default_options = {
    variant = "tritan",
    transparent = true,
    italic_comments = true,
    hide_fillchars = true,
    terminal_colors = true,
    borderless_pickers = true,
    diff_emphasis = "subtle",
    log_level = "warn",
    ---@diagnostic disable-next-line: missing-fields
    colors = {},
    highlights = {},

    extensions = {
        blinkcmp = true,
        cmp = true,
        gitsigns = true,
        indentblankline = true,
        lazy = true,
        markdown = true,
        mini = true,
        noice = true,
        notify = true,
        rainbow_delimiters = true,
        snacks = true,
        telescope = true,
        treesitter = true,
        treesittercontext = true,
        trouble = true,
        whichkey = true,
    },
}

---@type vividphantom.Config
M.options = {}

--- Expand `extensions.default = bool` into a full table of per-extension flags.
--- @param extensions table|nil
--- @return table|nil
local function expand_extensions(extensions)
    if not extensions or extensions.default == nil then
        return extensions
    end

    local default_value = extensions.default
    local user_extensions = vim.deepcopy(extensions)
    user_extensions.default = nil

    local out = {}
    for k, _ in pairs(default_options.extensions) do
        out[k] = default_value
    end
    for k, v in pairs(user_extensions) do
        out[k] = v
    end
    return out
end

--- Configure the colorscheme.
---
--- Resolution order (last wins):
---   1. defaults
---   2. `vim.g.vividphantom_opts` (read every call, so runtime changes apply)
---   3. `options` argument
---
--- The merged user-layer (without defaults) is written back to
--- `vim.g.vividphantom_opts`, so subsequent `setup()` calls and `:colorscheme`
--- reloads pick up a stable view of the user's intent.
--- @param options vividphantom.Config|nil
function M.setup(options)
    options = options or {}

    local g_opts = vim.g.vividphantom_opts
    if type(g_opts) ~= "table" then
        g_opts = {}
    end

    local user_layer = vim.tbl_deep_extend("force", {}, g_opts, options)
    user_layer.extensions = expand_extensions(user_layer.extensions)

    M.options = vim.tbl_deep_extend("force", {}, default_options, user_layer)
    vim.g.vividphantom_opts = user_layer
end

M.setup()

return M
