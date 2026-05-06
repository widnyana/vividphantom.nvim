# vividphantom.nvim

Tritanopia-safe Neovim colorscheme. Based on [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) by [Scott McKendry](https://github.com/scottmckendry), with the palette daltonized for blue-yellow (tritanopia) color vision deficiency.

## Requirements

- Neovim 0.9+
- A terminal with `termguicolors` support

## Install

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "widnyana/vividphantom.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
        require("vividphantom").setup(opts)
        vim.cmd.colorscheme("vividphantom")
    end,
}
```

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({
    "widnyana/vividphantom.nvim",
    config = function()
        require("vividphantom").setup({})
        vim.cmd.colorscheme("vividphantom")
    end,
})
```

[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'widnyana/vividphantom.nvim'
```

## Usage

```vim
:colorscheme vividphantom
```

Or in Lua:

```lua
vim.cmd.colorscheme("vividphantom")
```

## Configuration

Default options:

```lua
require("vividphantom").setup({
    transparent = true,         -- bg = NONE for Normal/NormalFloat/etc.
    italic_comments = true,
    hide_fillchars = true,      -- hide split/eob fillchars
    terminal_colors = true,     -- set vim.g.terminal_color_*
    borderless_pickers = true,  -- telescope/snacks pickers blend into bg_alt
    log_level = "warn",         -- "off" | "error" | "warn" | "info" | "debug" | "trace"
    colors = {},                -- palette overrides, e.g. { red = "#ff0000" }
    highlights = {},            -- highlight overrides (table or function(palette))
    extensions = {
        blinkcmp = true,
        cmp = true,
        gitsigns = true,
        indentblankline = true,
        lazy = true,
        markdown = true,        -- render-markdown.nvim
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
})
```

### Disabling all extensions except a few

```lua
require("vividphantom").setup({
    extensions = {
        default = false,        -- disables every extension
        treesitter = true,      -- ...except these
        gitsigns = true,
    },
})
```

### Highlight overrides as a function

```lua
require("vividphantom").setup({
    overrides = function(t)
        return {
            Comment = { fg = t.cyan, italic = true },
            ["@variable"] = { fg = t.fg, bold = true },
        }
    end,
})
```

### Configuration via `vim.g.vividphantom_opts`

`setup()` is optional. Any value set in `vim.g.vividphantom_opts` is treated as
configuration input, and `:colorscheme vividphantom` will pick it up.

```lua
vim.g.vividphantom_opts = {
    transparent = false,
    log_level = "info",
}
vim.cmd.colorscheme("vividphantom")
```

Resolution order (last wins):

1. defaults
2. `vim.g.vividphantom_opts`
3. arguments passed to `setup({...})`

After each `setup()` call, the merged user-layer (without defaults) is written
back to `vim.g.vividphantom_opts`, so subsequent reads and `:colorscheme`
reloads see a consistent view of intent. Mutating `vim.g.vividphantom_opts`
between reloads is honored on the next `:colorscheme vividphantom`.

### Logging

Extension load failures and similar diagnostics are routed through a level
filter controlled by `log_level`. Levels follow `vim.log.levels`:

| level   | emits                          |
|---------|--------------------------------|
| `off`   | nothing                        |
| `error` | errors                         |
| `warn`  | warnings + errors *(default)*  |
| `info`  | info + warn + error            |
| `debug` | debug and above                |
| `trace` | everything                     |

Misspelled or third-party extension keys (e.g. `extensions = { foo = true }`)
will surface as a `warn` notification at the default level — set `log_level = "off"`
to silence, or `"info"` to see what the loader is doing.

## Structure

```
vividphantom.nvim/
├── colors/
│   └── vividphantom.lua          -- thin loader
└── lua/vividphantom/
    ├── init.lua                  -- public API: setup, load
    ├── config.lua                -- defaults + setup()
    ├── colors.lua                -- palette
    ├── theme.lua                 -- highlight builder
    ├── util.lua                  -- blend, syntax, load
    └── extensions/
        ├── base.lua              -- core vim + LSP groups
        ├── treesitter.lua
        ├── telescope.lua
        ├── cmp.lua
        ├── blinkcmp.lua
        ├── gitsigns.lua
        ├── lazy.lua
        ├── notify.lua
        ├── noice.lua
        ├── snacks.lua
        ├── whichkey.lua
        ├── trouble.lua
        ├── indentblankline.lua
        ├── rainbow_delimiters.lua
        ├── mini.lua
        ├── markdown.lua
        └── treesittercontext.lua
```

## Credits

This project is a fork of [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) by [Scott McKendry](https://github.com/scottmckendry). The original palette, highlight structure, and extension system are derived from that work. vividphantom modifies the color choices to be distinguishable under tritanopia (blue-yellow color vision deficiency) while preserving the cyberdream aesthetic.
