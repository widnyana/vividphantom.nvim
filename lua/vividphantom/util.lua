local M = {}

--- @alias RGB number[]

--- Notify the user with a message.
--- @param message string
--- @param level? "info" | "warn" | "error"
--- @param title? string
function M.notify(message, level, title)
    level = level or "info"
    title = title or "vividphantom.nvim"
    local level_int = level == "info" and 2 or level == "warn" and 3 or 4
    vim.notify(message, level_int, { title = title })
end

--- Apply a table of highlight groups.
--- @param syntax table<string, table>
function M.syntax(syntax)
    for group, attrs in pairs(syntax) do
        vim.api.nvim_set_hl(0, group, attrs)
    end
end

--- Convert a hex color to an RGB triple.
--- @param hex string "#rrggbb"
--- @return RGB
function M.hex_to_rgb(hex)
    return {
        tonumber(hex:sub(2, 3), 16),
        tonumber(hex:sub(4, 5), 16),
        tonumber(hex:sub(6, 7), 16),
    }
end

--- Blend two hex colors. Returns "NONE" if either input is "NONE".
--- @param c1 string
--- @param c2 string
--- @param weight? number weight of c1 (0..1), defaults to 0.5
--- @return string
function M.blend(c1, c2, weight)
    weight = weight or 0.5
    if c1 == "NONE" or c2 == "NONE" then
        return "NONE"
    end
    local r1 = M.hex_to_rgb(c1)
    local r2 = M.hex_to_rgb(c2)
    return string.format(
        "#%02x%02x%02x",
        math.floor(r1[1] * weight + r2[1] * (1 - weight)),
        math.floor(r1[2] * weight + r2[2] * (1 - weight)),
        math.floor(r1[3] * weight + r2[3] * (1 - weight))
    )
end

--- Apply the colorscheme.
--- @param theme { highlights: table<string, table> }
function M.load(theme)
    if vim.g.colors_name then
        vim.cmd("hi clear")
    end
    vim.o.termguicolors = true
    vim.g.colors_name = "vividphantom"
    M.syntax(theme.highlights)
end

return M
