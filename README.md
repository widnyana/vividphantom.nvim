# vividphantom.nvim

Tritanopia-safe Neovim colorscheme. Based on [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) by [Scott McKendry](https://github.com/scottmckendry), with the palette daltonized for blue-yellow (tritanopia) color vision deficiency.

The original cyberdream palette leans heavily on yellow/blue contrast, which collapses for people with tritanopia. vividphantom keeps the same dark, transparent aesthetic but swaps the discriminator pairs over to red/green/magenta/cyan so syntax categories stay visually distinct.

A second palette is available for **protanopia / protanomaly** (red-green CVD, weak L cones) via `variant = "protan"`. See [Variants](#variants) below.

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
        require("vividphantom").setup({})
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

Then in your Lua config:

```lua
vim.cmd.colorscheme("vividphantom")
```

### LazyVim

If you use LazyVim, set the colorscheme via its `opts.colorscheme` and let your plugin spec self-apply:

```lua
return {
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "vividphantom" },
    },
    {
        "widnyana/vividphantom.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("vividphantom").setup({})
            vim.cmd.colorscheme("vividphantom")
        end,
    },
}
```

## Quick start

```vim
:colorscheme vividphantom
```

That's the whole minimum. Defaults are tuned to be reasonable; everything below is optional.

## Variants

vividphantom ships with two palettes, each tuned for a different color-vision profile:

| variant   | tuned for                                       | default? |
|-----------|-------------------------------------------------|:--------:|
| `tritan`  | tritanopia / tritanomaly *(blue-yellow CVD)*    | yes      |
| `protan`  | protanopia / protanomaly *(red-green CVD)*      |          |

Pick one with the `variant` option:

```lua
require("vividphantom").setup({ variant = "protan" })
```

Or via `vim.g.vividphantom_opts`:

```lua
vim.g.vividphantom_opts = { variant = "protan" }
```

Both variants share the same structural settings (transparency, italic comments, extension toggles, etc.) — only the palette differs.

### Which one should I pick?

Use the symptom that bites you in day-to-day editing — not a clinical label.

- Pick **`protan`** if reds and dark reds look near-black, if `git diff` add/remove lines feel mushy, if you confuse red with green or orange, or if an eye exam has flagged red-green deficiency.
- Pick **`tritan`** if yellows and blues bleed into each other, if you have trouble telling cyan from green, or an exam has flagged blue-yellow deficiency.
- If you don't know, try both — `:VividphantomDemo` (see [Preview the palette](#preview-the-palette)) renders every semantic role in one buffer. Keep the variant where errors, warnings, and success/diff-add are easiest to tell apart at a glance.
- Neither variant directly targets deuteranopia (the most common red-green CVD); `protan` is a reasonable starting point but hasn't been validated against a deutan simulator. If specific groups collide for you, override them via `colors = { ... }`.

### Why two?

Different CVD types collapse different axes of color perception, so a single palette can't cover both well.

- **Tritan** types lose the **blue–yellow** axis. The default palette compensates by leaning on red, green, magenta, cyan, and pink as the primary discriminators.
- **Protan** types lose the **red–green** axis (weak L cones). Dark red can appear near-black, and red/orange/yellow/green collapse together. The protan palette keeps the same dark, transparent chassis but:
    - shifts `red` toward a bright pink-magenta so errors carry blue-channel signal and don't sink into the background,
    - leans `green` cool (toward cyan) so success doesn't merge with warnings,
    - uses a high-luminance pure `yellow` for warnings,
    - leaves `blue`, `cyan`, `purple`, and `magenta` close to canonical — the S cone is unaffected, so these anchor most semantic roles.

If you want to fine-tune the chosen variant further, pair `variant` with `colors = { ... }` overrides:

```lua
require("vividphantom").setup({
    variant = "protan",
    colors = { red = "#ff5e80" },  -- nudge the error hue
})
```

## Preview the palette

Once a variant is active, open the demo buffer to see every semantic role at a glance:

```vim
:VividphantomDemo
```

Or from Lua:

```lua
require("vividphantom").demo()
```

The buffer renders palette swatches, diagnostic groups (error/warn/info/hint), diff and gitsigns groups, common syntax categories, and UI groups (search, visual, pmenu) — each labelled by its highlight group name. Useful for screenshotting and feeding into a CVD simulator (Color Oracle, Sim Daltonism, [coblis](https://www.color-blindness.com/coblis-color-blindness-simulator/)) to verify the palette holds under your specific deficiency before relying on it for daily work.

## Configuration

All options with their defaults:

```lua
require("vividphantom").setup({
    variant = "tritan",         -- "tritan" | "protan"
    transparent = true,         -- Normal/NormalFloat use bg=NONE
    italic_comments = true,
    hide_fillchars = true,      -- hide split / end-of-buffer fillchars
    terminal_colors = true,     -- populate vim.g.terminal_color_*
    borderless_pickers = true,  -- telescope/snacks pickers blend into bg_alt
    diff_emphasis = "subtle",   -- "subtle" | "high" — stronger tint for diff bg
    log_level = "warn",         -- "off" | "error" | "warn" | "info" | "debug" | "trace"
    colors = {},                -- palette overrides
    highlights = {},            -- highlight overrides (table or function(palette))
    overrides = nil,            -- alias for `highlights` when used as a function
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

## Recipes

### Solid (non-transparent) background

```lua
require("vividphantom").setup({ transparent = false })
```

### Non-italic comments

```lua
require("vividphantom").setup({ italic_comments = false })
```

### Stronger diff tints (recommended for protan readers)

The default `diff_emphasis = "subtle"` blends each diff color at 80/20 with
the real background, matching the original aesthetic. Under protan
simulation those tints lose saturation; if `git diff` add/remove blocks
feel mushy, switch to `"high"` (70/30 blend):

```lua
require("vividphantom").setup({
    variant = "protan",
    diff_emphasis = "high",
})
```

Affects `DiffAdd`, `DiffChange`, `DiffDelete`, `DiffText`, and the
matching `MiniDiffOver*` groups. Tritan readers can opt in too — purely
aesthetic for them.

### Cherry-pick extensions

Disable everything, then re-enable what you actually use:

```lua
require("vividphantom").setup({
    extensions = {
        default = false,
        treesitter = true,
        gitsigns = true,
        snacks = true,
    },
})
```

### Override colors in the palette

```lua
require("vividphantom").setup({
    colors = {
        red = "#ff5050",
        cyan = "#7ee8e8",
    },
})
```

### Override specific highlight groups

As a flat table:

```lua
require("vividphantom").setup({
    highlights = {
        Comment = { fg = "#777777", italic = false },
        ["@variable"] = { bold = true },
    },
})
```

As a function (gives you access to the resolved palette):

```lua
require("vividphantom").setup({
    overrides = function(t)
        return {
            Comment = { fg = t.cyan, italic = true },
            CursorLine = { bg = t.bg_highlight },
        }
    end,
})
```

The palette `t` exposes:
`bg`, `bg_alt`, `bg_highlight`, `bg_solid`, `fg`, `grey`,
`blue`, `green`, `cyan`, `red`, `yellow`, `magenta`, `pink`, `orange`, `purple`.

`bg_solid` is the real background even when `transparent = true` — use it as the foreground when you need dark-on-color contrast that survives transparency.

### Configure via `vim.g.vividphantom_opts`

`setup()` is optional. Anything in `vim.g.vividphantom_opts` is treated as configuration input:

```lua
vim.g.vividphantom_opts = {
    transparent = false,
    italic_comments = false,
}
vim.cmd.colorscheme("vividphantom")
```

Resolution order (last wins): `defaults` → `vim.g.vividphantom_opts` → `setup({...})` argument.

After each `setup()` call, the merged user-layer (without defaults) is written back to `vim.g.vividphantom_opts`. Mutating it between `:colorscheme vividphantom` reloads is honored.

### Adjust logging verbosity

Diagnostics (e.g. enabled extension that fails to load) are filtered through `log_level`:

| level   | emits                          |
|---------|--------------------------------|
| `off`   | nothing                        |
| `error` | errors only                    |
| `warn`  | warnings + errors *(default)*  |
| `info`  | info + warn + error            |
| `debug` | debug and above                |
| `trace` | everything                     |

```lua
require("vividphantom").setup({ log_level = "off" })   -- silence everything
require("vividphantom").setup({ log_level = "info" })  -- see what the loader is doing
```

## Supported plugins

Highlights are tuned for:

| plugin                    | extension key         |
|---------------------------|-----------------------|
| Treesitter                | `treesitter`          |
| Treesitter Context        | `treesittercontext`   |
| Telescope                 | `telescope`           |
| nvim-cmp                  | `cmp`                 |
| blink.cmp                 | `blinkcmp`            |
| Gitsigns                  | `gitsigns`            |
| Lazy                      | `lazy`                |
| Noice                     | `noice`               |
| nvim-notify               | `notify`              |
| Snacks (picker, dashboard, notifier) | `snacks`   |
| WhichKey                  | `whichkey`            |
| Trouble                   | `trouble`             |
| IndentBlankline           | `indentblankline`     |
| Rainbow Delimiters        | `rainbow_delimiters`  |
| mini.nvim suite           | `mini`                |
| render-markdown.nvim      | `markdown`            |

Plus core LSP / diagnostic groups and standard Vim syntax — those are always on.

## Troubleshooting

### `:colorscheme vividphantom` is silently a no-op

Check for stray files in `~/.config/nvim/colors/`:

```
ls ~/.config/nvim/colors/
```

If you have a leftover `vividphantom.lua.bak`, `vividphantom.lua.old`, or any sibling
file with `vividphantom` in the name, move it out. Neovim's colorscheme resolver can
get confused by neighbours in `colors/` even when their extension isn't `.lua` or `.vim`,
silently failing to source the right file (the call returns success with `g:colors_name` left unset).

### Search / IncSearch text is unreadable

You're on a stale revision. Update — recent versions anchor the foreground on `bg_solid` so search highlights stay legible in transparent mode.

### Pickers are fully transparent

That's the default with `transparent = true`. Either flip transparency off, or disable just the picker integration:

```lua
require("vividphantom").setup({ borderless_pickers = false })
```

### Comments aren't italic

Your terminal or font may not render italic. Try a font with italic glyphs (e.g. JetBrainsMono, Cascadia Code, Iosevka), or disable explicitly:

```lua
require("vividphantom").setup({ italic_comments = false })
```

## Credits

- [cyberdream.nvim](https://github.com/scottmckendry/cyberdream.nvim) — the original aesthetic and modular architecture this fork inherits from.

## License

MIT. See [LICENSE](LICENSE). The file preserves the upstream cyberdream.nvim copyright alongside this fork's.
