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

---@class vividphantom.Config
---@field transparent? boolean
---@field italic_comments? boolean
---@field hide_fillchars? boolean
---@field terminal_colors? boolean
---@field borderless_pickers? boolean
---@field colors? vividphantom.Palette
---@field highlights? table<string, vividphantom.Highlight> | vividphantom.OverrideFn
---@field overrides? vividphantom.OverrideFn
---@field extensions? vividphantom.Extensions
local default_options = {
    transparent = true,
    italic_comments = true,
    hide_fillchars = true,
    terminal_colors = true,
    borderless_pickers = true,
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

---@param options vividphantom.Config|nil
function M.setup(options)
    options = options or {}

    if options.extensions and options.extensions.default ~= nil then
        local default_value = options.extensions.default
        local user_extensions = vim.deepcopy(options.extensions)
        user_extensions.default = nil

        local extensions = {}
        for k, _ in pairs(default_options.extensions) do
            extensions[k] = default_value
        end
        for k, v in pairs(user_extensions) do
            extensions[k] = v
        end
        options.extensions = extensions
    end

    M.options = vim.tbl_deep_extend("force", {}, default_options, options)
    vim.g.vividphantom_opts = M.options
end

M.setup()

return M
