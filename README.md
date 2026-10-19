# dotfiles

tmux + Neovim setup, Dracula everywhere. Tuned for Elixir and TypeScript, with habits
carried over from Cursor (2-space tabs, format on save, Prettier + `mix format`, `<C-p>`
for quick-open, `K` for hover docs).

## Requirements

- macOS with [Homebrew](https://brew.sh)
- A [Nerd Font](https://www.nerdfonts.com) — Monaspace Neon recommended (icons in statusline/tree break without it)
- _(Optional)_ Dracula Pro license — nvim falls back to OSS dracula.nvim automatically

## Install

```sh
git clone git@github.com:filipemonteiroth/dotfiles.git ~/development/dotfiles
cd ~/development/dotfiles
./install.sh
```

The script:
1. Symlinks `~/.tmux.conf` and `~/.config/nvim` (backs up anything in the way to `*.bak.<timestamp>`)
2. Installs brew deps: `neovim`, `tmux`, `ripgrep`, `fd`, `lazygit`, `tree-sitter-cli`, `node`, `elixir`, and the Monaspace Nerd Font
3. Clones [tpm](https://github.com/tmux-plugins/tpm) for tmux plugin management

**After install:**

```sh
# 1. Start tmux and install plugins
tmux
# then press: C-a I

# 2. Open nvim — lazy.nvim bootstraps on first launch (takes ~1 min)
nvim
```

LSPs (ElixirLS, vtsls, eslint, tailwindcss, graphql, jsonls, yamlls, lua_ls) install
automatically via Mason. ElixirLS dialyzer takes a few minutes on first project open.

---

## Repository layout

```
install.sh                  symlinks + brew deps + tpm setup
tmux/
  tmux.conf                 C-a prefix, splits, vi copy mode, Dracula, session persistence
  dracula-pro/              per-variant palette files (alucard, blade, buffy, …)
nvim/
  init.lua                  entry point (loads lua/config/)
  lua/config/
    options.lua             editor settings (2-space, relative numbers, system clipboard…)
    keymaps.lua             global keymaps
    autocmds.lua            autocommands
    lazy.lua                lazy.nvim bootstrap
  lua/plugins/
    lsp.lua                 nvim-lspconfig + Mason (ElixirLS, vtsls, eslint…)
    completion.lua          blink.cmp
    formatting.lua          conform.nvim (format on save)
    telescope.lua           fuzzy finder
    neo-tree.lua            file explorer
    git.lua                 gitsigns + lazygit
    bufferline.lua          Cursor-style buffer tabs
    editor.lua              vim-tmux-navigator, autopairs, surround, todo-comments
    treesitter.lua          syntax/indentation
    colorscheme.lua         Dracula Pro (vendored) → falls back to dracula.nvim
    ui.lua                  lualine, which-key, fidget
zsh/dracula.zsh             prompt, plugins, fzf/zoxide/eza/bat, Dracula colors (sourced from ~/.zshrc)
starship/starship.toml      Starship prompt: git branch/status/metrics, node/elixir, AWS, k8s
git/gitconfig               delta pager, Dracula colors, zdiff3, aliases (included from ~/.gitconfig)
lazygit/config.yml          Dracula theme + delta diffs
```

---

## Cheat sheet

**Leader** = `<Space>`

### tmux — prefix `C-a`

> `C-a |` = hold Ctrl, press `a`, release both, **then** press `|`.
> The prefix is invisible — tmux waits for the next key.
> Press `C-a C-a` to send a literal `Ctrl+A` to the shell (jump to line start).
> `C-a ?` lists every binding.

#### Panes & windows

| Keys | Action |
|---|---|
| `C-a \|` | Split right (horizontal), keeps cwd |
| `C-a -` | Split down (vertical), keeps cwd |
| `C-h / C-j / C-k / C-l` | Navigate panes **and** nvim splits — no prefix needed |
| `C-a h / j / k / l` | Resize pane (5 rows/cols per press) |
| `C-a m` | Zoom / un-zoom pane |
| `C-a c` | New window |
| `C-a ,` | Rename window |
| `C-a n / p` | Next / prev window |

#### Session & misc

| Keys | Action |
|---|---|
| `C-a I` | Install plugins (tpm) |
| `C-a U` | Update plugins |
| `C-a r` | Reload `~/.tmux.conf` |
| `C-a d` | Detach session |
| `C-a $` | Rename session |
| `C-a s` | List / switch sessions |
| `C-a C-l` | Clear screen (replaces the `C-l` stolen by vim-tmux-navigator) |

#### Copy mode (vi)

| Keys | Action |
|---|---|
| `C-a [` | Enter copy mode |
| `v` | Begin selection |
| `y` / `Enter` | Copy selection to macOS clipboard |
| `q` | Exit copy mode |
| `Opt+←` / `Opt+→` | Word left / right |

#### Dracula Pro variant (tmux)

Edit the `source-file` line near the bottom of `tmux/tmux.conf`, then `C-a r`:

```
source-file ~/development/dotfiles/tmux/dracula-pro/<variant>.conf
```

Variants: `pro` · `blade` · `buffy` · `lincoln` · `morbius` · `van_helsing` · `alucard` (light)

---

### zsh + git

| Key / command | Action |
|---|---|
| `→` / `End` | accept autosuggestion (grey text) |
| `↑` / `↓` | history search by the prefix already typed |
| `C-r` / `C-t` / `Alt-c` | fzf: history / insert file / cd into dir |
| `z <dir>` / `zi` | zoxide jump / interactive jump |
| `ll` `la` `lt` | eza long / all / tree (with git status) |
| `fco` | fuzzy checkout branch (sorted by recent) |
| `flog` | fuzzy browse log, Enter opens commit in delta |
| `lg` | lazygit |
| `git lg` / `git lga` | pretty graph log (current / all branches) |
| `git recent` / `git st` | branches by recency / short status |
| `n` / `N` in a diff | delta: jump between files |

### Neovim

#### Files & search (Telescope)

| Keys | Action |
|---|---|
| `<C-p>` / `<leader>ff` | Find files (the Cmd+P habit) |
| `<leader>fg` | Live grep (ripgrep) |
| `<leader>fw` | Grep word under cursor |
| `<leader>fb` | Browse open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fd` | All diagnostics |
| `<leader>fR` | Resume last picker |
| `<leader>fc` | Pick colorscheme (live preview) |

#### File explorer (Neo-tree)

| Keys | Action |
|---|---|
| `<leader>e` | Toggle file tree |
| `<leader>E` | Reveal current file in tree |

#### Buffer tabs (bufferline)

| Keys | Action |
|---|---|
| `Shift+h` / `Shift+l` | Prev / next buffer tab |
| `<leader>1` … `<leader>5` | Jump to buffer tab 1–5 |
| `<leader>bd` | Close current buffer (use this, not `:q`) |
| `<leader>bo` | Close all other buffers |
| `<leader>bp` | Pin / unpin buffer tab |

#### LSP

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover docs |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |

#### Diagnostics

| Keys | Action |
|---|---|
| `<leader>d` | Show diagnostics float for current line |
| `[d` / `]d` | Prev / next diagnostic |

#### Git (gitsigns + lazygit)

| Keys | Action |
|---|---|
| `<leader>gg` | Open lazygit (floating window) |
| `]h` / `[h` | Next / prev hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk diff |
| `<leader>hb` | Full blame for current line |
| `<leader>hd` | Diff this file |

Inline blame (gitlens-style) is always on with a 500ms delay.

#### Editing

| Keys | Action |
|---|---|
| `<leader>f` | Format buffer (also runs on save) |
| `<leader>w` | Save file |
| `<leader>q` | Quit window |
| `<Esc>` | Clear search highlight |
| `<C-d>` / `<C-u>` | Scroll half-page (cursor stays centered) |
| `n` / `N` | Next/prev search match (cursor stays centered) |
| `>` / `<` (visual) | Indent / dedent, keep selection |
| `J` / `K` (visual) | Move selected lines down / up |

#### Surround (nvim-surround)

| Keys | Action |
|---|---|
| `ysiw"` | Surround inner word with `"` |
| `cs"'` | Change surrounding `"` to `'` |
| `ds"` | Delete surrounding `"` |
| `yss)` | Surround entire line with `()` |

#### Misc

| Keys | Action |
|---|---|
| `<leader>` (pause) | which-key — shows all available bindings for that prefix |

---

## Language support

### Elixir

- **LSP**: ElixirLS with dialyzer enabled (`dialyxir_short` format)
- **Format on save**: `mix format`
- **Treesitter**: `elixir`, `heex`, `eex`

### TypeScript / JavaScript

- **LSPs**: vtsls, eslint, tailwindcss, graphql
- **Format on save**: prettierd → prettier (first found)
- **Extras**: ts-error-translator (human-readable TS errors), nvim-ts-autotag (auto-close JSX/HTML tags)

### Other formatters (format on save)

| Language | Formatter |
|---|---|
| Lua | stylua |
| JSON | prettierd |
| CSS / HTML | prettierd |
| GraphQL | prettierd |
| Markdown | prettierd |

---

## Plugins at a glance

| Plugin | Role |
|---|---|
| lazy.nvim | Plugin manager |
| Mason | LSP / formatter installer |
| nvim-lspconfig | LSP client config |
| blink.cmp | Completion (Enter to accept) |
| conform.nvim | Format on save |
| Telescope | Fuzzy finder |
| Neo-tree | File explorer |
| gitsigns.nvim | Git hunk signs + inline blame |
| lazygit.nvim | lazygit TUI in a float |
| bufferline.nvim | Buffer tabs (Cursor-style) |
| lualine.nvim | Statusline |
| which-key.nvim | Keymap hints |
| fidget.nvim | LSP progress notifications |
| vim-tmux-navigator | Seamless pane/split navigation |
| nvim-autopairs | Auto-close brackets/do-end |
| nvim-ts-autotag | Auto-close HTML/JSX tags |
| nvim-surround | ys / cs / ds surround |
| todo-comments.nvim | Highlight TODO/FIXME/NOTE |
| nvim-treesitter | Syntax + indentation |
| ts-error-translator | Readable TypeScript errors |
| Dracula Pro / dracula.nvim | Colorscheme |

---

## Dracula Pro

The paid Dracula Pro package is expected at `~/development/Dracula Pro`. `install.sh`
vendors it into `nvim/vendor/dracula-pro/` on each machine — that directory is gitignored.
Without the package nvim falls back to OSS `dracula.nvim` automatically.

The license is per-user. Never commit or publish the theme files.

**Switching variants in nvim:** `<leader>fc` for a live picker, or:

```
:colorscheme dracula-pro-blade
```

Available: `dracula-pro` · `dracula-pro-blade` · `dracula-pro-buffy` · `dracula-pro-lincoln`
· `dracula-pro-morbius` · `dracula-pro-van-helsing` · `dracula-pro-alucard` (light)

---

## Notes

- tmux sessions auto-save every 15 min (continuum) and restore on restart (resurrect).
- Safe to re-run `install.sh` — existing real files get backed up to `*.bak.<timestamp>`,
  correct symlinks are left alone.
- First nvim launch: lazy.nvim installs all plugins, Mason installs LSPs — expect ~1 min.
  ElixirLS dialyzer is slow on the first project open.
