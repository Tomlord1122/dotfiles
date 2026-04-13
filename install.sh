#!/bin/bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dst="$2"

  # For directory targets, back up if it's a real directory (not a symlink)
  if [[ -d "$dst" && ! -L "$dst" ]]; then
    local backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "  Backing up existing directory: $dst -> $backup"
    mv "$dst" "$backup"
  fi

  # -s: symbolic, -h: don't follow if dst is a symlink, -f: force replace
  ln -shf "$src" "$dst"
  echo "  Linked: $dst -> $src"
}

echo "==> Linking dotfiles from $DOTFILES_ROOT"

link "$DOTFILES_ROOT/.gitconfig"  "$HOME/.gitconfig"
link "$DOTFILES_ROOT/.bashrc"     "$HOME/.bashrc"
link "$DOTFILES_ROOT/.zshrc"      "$HOME/.zshrc"
link "$DOTFILES_ROOT/.p10k.zsh"   "$HOME/.p10k.zsh"
link "$DOTFILES_ROOT/.tmux.conf"  "$HOME/.tmux.conf"

echo "==> Linking config directories"

mkdir -p "$HOME/.config"
link "$DOTFILES_ROOT/config/ghostty" "$HOME/.config/ghostty"
link "$DOTFILES_ROOT/config/nvim"    "$HOME/.config/nvim"

echo "==> Done"
