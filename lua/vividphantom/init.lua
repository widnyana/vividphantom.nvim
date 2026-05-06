local theme = require("vividphantom.theme")
local config = require("vividphantom.config")
local util = require("vividphantom.util")

local M = {}

function M.load()
    util.load(theme.setup())
end

M.setup = config.setup
M.colorscheme = M.load

return M
