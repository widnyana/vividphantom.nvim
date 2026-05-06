local theme = require("vividphantom.theme")
local config = require("vividphantom.config")
local util = require("vividphantom.util")

local M = {}

function M.load()
    -- Re-resolve options from vim.g.vividphantom_opts so runtime changes
    -- between :colorscheme reloads take effect without an explicit setup() call.
    config.setup()
    util.load(theme.setup())
end

M.setup = config.setup
M.colorscheme = M.load

function M.demo()
    require("vividphantom.demo").open()
end

vim.api.nvim_create_user_command("VividphantomDemo", function()
    M.demo()
end, { desc = "Open a vividphantom palette / highlight-group demo buffer", force = true })

return M
