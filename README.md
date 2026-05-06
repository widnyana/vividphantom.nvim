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
  config = function()
    vim.cmd.colorscheme("vividphantom")
  end,
}
```

[packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use({ "widnyana/vividphantom.nvim" })
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

## Supported plugins

Custom highlight groups are provided for:

- Treesitter, LSP, Diagnostics
- Telescope, Snacks (picker, dashboard, notifier)
- nvim-cmp, blink.cmp
- Gitsigns, Lazy, Noice, Notify
- WhichKey, Trouble, IndentBlankline
- Rainbow Delimiters, Render Markdown
- mini.nvim suite, Treesitter Context
