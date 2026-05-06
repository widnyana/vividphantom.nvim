# vividphantom.nvim

Tritanopia-safe Neovim colorscheme. Cyberdream-inspired aesthetic with a daltonized palette tuned for blue-yellow color vision deficiency.

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
