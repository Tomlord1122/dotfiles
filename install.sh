#!/bin/bash

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$DOTFILES_ROOT/.gitconfig" "$HOME/.gitconfig"

mv "$HOME/.bashrc" "$HOME/.oldbashrc" &> /dev/null
ln -sf "$DOTFILES_ROOT/.bashrc" "$HOME/.bashrc"

mv "$HOME/.zshrc" "$HOME/.oldzshrc" &> /dev/null
ln -sf "$DOTFILES_ROOT/.zshrc" "$HOME/.zshrc"

mv "$HOME/.p10k.zsh" "$HOME/.oldp10k.zsh" &> /dev/null
ln -sf "$DOTFILES_ROOT/.p10k.zsh" "$HOME/.p10k.zsh"


ln -sf "$DOTFILES_ROOT/.tmux.conf" "$HOME/.tmux.conf"

mkdir -p "$HOME/.config"
GHOSTTY_SRC="$DOTFILES_ROOT/config/ghostty"
GHOSTTY_DST="$HOME/.config/ghostty"
if [[ -L "$GHOSTTY_DST" ]]; then
	rm -f "$GHOSTTY_DST"
fi
if [[ -e "$GHOSTTY_DST" && ! -L "$GHOSTTY_DST" ]]; then
	mv "$GHOSTTY_DST" "${GHOSTTY_DST}.bak.$(date +%Y%m%d%H%M%S)"
fi
ln -sf "$GHOSTTY_SRC" "$GHOSTTY_DST"

# Neovim
NVIM_SRC="$DOTFILES_ROOT/config/nvim"
NVIM_DST="$HOME/.config/nvim"
if [[ -L "$NVIM_DST" ]]; then
	rm -f "$NVIM_DST"
fi
if [[ -e "$NVIM_DST" && ! -L "$NVIM_DST" ]]; then
	mv "$NVIM_DST" "${NVIM_DST}.bak.$(date +%Y%m%d%H%M%S)"
fi
ln -sf "$NVIM_SRC" "$NVIM_DST"
