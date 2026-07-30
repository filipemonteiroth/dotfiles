#!/usr/bin/env bash
#
# Symlinks dotfiles into place and installs dependencies.
# Safe to re-run: existing real files are backed up to *.bak.<timestamp>,
# existing correct symlinks are left alone.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.bak.$STAMP"
    echo "backup  $dst -> $dst.bak.$STAMP"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "link    $dst -> $src"
}

echo "==> Symlinking configs"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES/nvim" "$HOME/.config/nvim"

echo "==> Installing dependencies (brew)"
if command -v brew >/dev/null; then
  # ripgrep/fd: telescope grep + file finding; make: telescope-fzf-native build
  # tree-sitter-cli: required by nvim-treesitter (main branch) to build parsers
  for pkg in neovim tmux ripgrep fd lazygit tree-sitter-cli; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
  done
else
  echo "brew not found — install neovim, tmux, ripgrep, fd, lazygit manually"
fi

echo "==> Dracula Pro (licensed — vendored locally, never committed)"
DRACULA_PRO="$HOME/development/Dracula Pro"
if [ -d "$DRACULA_PRO/themes/vim" ]; then
  mkdir -p "$DOTFILES/nvim/vendor"
  rsync -a --delete "$DRACULA_PRO/themes/vim/" "$DOTFILES/nvim/vendor/dracula-pro/"
  echo "vendored nvim theme from $DRACULA_PRO"
  if [ -d "$HOME/.oh-my-zsh" ] && [ -f "$DRACULA_PRO/themes/zsh/dracula-pro.zsh-theme" ]; then
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    cp "$DRACULA_PRO/themes/zsh/dracula-pro.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/"
    echo "installed zsh prompt theme (set ZSH_THEME=\"dracula-pro\" in ~/.zshrc)"
  fi
else
  echo "not found at $DRACULA_PRO — nvim falls back to OSS dracula.nvim"
fi

echo "==> tmux plugin manager (tpm)"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo
echo "Done. Next steps:"
echo "  1. tmux: start tmux, then prefix + I (C-a I) to install plugins (incl. Dracula theme)"
echo "     If tmux is already running: tmux source ~/.tmux.conf"
echo "  2. nvim: open nvim — lazy.nvim bootstraps and installs everything on first run"
echo "     LSPs (ElixirLS, vtsls, etc.) install automatically via Mason"
