# Configurations

This repo now includes a portable bootstrap script that installs the core tools,
sets up `oh-my-zsh`, shell plugins, `tmux` TPM, optional toolchains, and then
symlinks the dotfiles into `$HOME`.

## Quick Start

```bash
git clone <your-dotfiles-repo> "$HOME/dotfiles"
cd "$HOME/dotfiles"
./install.sh
```

## What `install.sh` does

- detects the current OS (`macOS` or `Linux`)
- installs core packages with `brew` or `apt-get`
- installs `oh-my-zsh`
- installs `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- installs `tmux` TPM
- installs optional toolchains: `bun`, `nvm`, `rustup`
- symlinks this repo's config files into `$HOME` and `$HOME/.config`
- tries to switch the default shell to `zsh`

## Optional Flags

```bash
./install.sh --link-only
./install.sh --skip-packages
./install.sh --skip-optional-toolchains
```

- `--link-only`: only create/update symlinks under `$HOME`
- `--skip-packages`: skip `brew`/`apt-get` package installation
- `--skip-optional-toolchains`: skip `bun`, `nvm`, `rustup`

## Notes

- existing real files/directories are backed up with a timestamp before being replaced
- shell config avoids hard-coded machine-specific paths where possible
- some app-specific tools, fonts, accounts, and secrets still need to be handled separately
