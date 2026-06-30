#!/usr/bin/env bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
SKIP_PACKAGES=0
SKIP_OPTIONAL_TOOLCHAINS=0
SKIP_EXTERNAL_INSTALLS=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --link-only                 Only create/update symlinks under $HOME
  --skip-packages            Skip brew/apt-get package installation
  --skip-optional-toolchains Skip Bun, nvm, and rustup installation
  --help                     Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --link-only)
      SKIP_PACKAGES=1
      SKIP_OPTIONAL_TOOLCHAINS=1
      SKIP_EXTERNAL_INSTALLS=1
      ;;
    --skip-packages)
      SKIP_PACKAGES=1
      ;;
    --skip-optional-toolchains)
      SKIP_OPTIONAL_TOOLCHAINS=1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

log() {
  printf '==> %s\n' "$1"
}

warn() {
  printf 'Warning: %s\n' "$1" >&2
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

backup_path() {
  local target="$1"

  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    printf '  Backing up existing path: %s -> %s\n' "$target" "$backup"
    mv "$target" "$backup"
  fi
}

link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current_target
    current_target="$(readlink "$dst" || true)"
    if [[ "$current_target" == "$src" ]]; then
      printf '  Already linked: %s\n' "$dst"
      return
    fi
  fi

  backup_path "$dst"
  ln -sfn "$src" "$dst"
  printf '  Linked: %s -> %s\n' "$dst" "$src"
}

install_with_brew() {
  local packages=("$@")
  local missing=()
  local package

  for package in "${packages[@]}"; do
    if brew list "$package" >/dev/null 2>&1; then
      continue
    fi
    missing+=("$package")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    brew install "${missing[@]}"
  fi
}

install_with_apt() {
  local packages=("$@")
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"
}

ensure_homebrew() {
  if has_cmd brew; then
    return
  fi

  if ! has_cmd curl; then
    warn "curl is required to install Homebrew automatically"
    return
  fi

  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$OS" == "Darwin" && -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ "$OS" == "Darwin" && -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
  fi
}

install_core_packages() {
  if [[ "$SKIP_PACKAGES" -eq 1 ]]; then
    return
  fi

  log "Installing core packages"

  case "$OS" in
    Darwin)
      ensure_homebrew
      if has_cmd brew; then
        install_with_brew git curl zsh tmux neovim fzf ripgrep fd
      else
        warn "Homebrew installation failed; skipping package installation"
      fi
      ;;
    Linux)
      if has_cmd apt-get; then
        install_with_apt git curl zsh tmux neovim fzf ripgrep fd-find xclip wl-clipboard
      elif has_cmd brew; then
        install_with_brew git curl zsh tmux neovim fzf ripgrep fd
      else
        warn "No supported package manager found; skipping package installation"
      fi
      ;;
    *)
      warn "Unsupported OS: $OS"
      ;;
  esac
}

clone_or_update() {
  local repo_url="$1"
  local dst="$2"

  if ! has_cmd git; then
    warn "git is required to clone $repo_url"
    return
  fi

  if [[ -d "$dst/.git" ]]; then
    git -C "$dst" pull --ff-only
    return
  fi

  mkdir -p "$(dirname "$dst")"
  git clone --depth=1 "$repo_url" "$dst"
}

install_oh_my_zsh() {
  if [[ "$SKIP_EXTERNAL_INSTALLS" -eq 1 ]]; then
    return
  fi

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    return
  fi

  if ! has_cmd curl; then
    warn "curl is required to install oh-my-zsh"
    return
  fi

  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_shell_plugins() {
  if [[ "$SKIP_EXTERNAL_INSTALLS" -eq 1 ]]; then
    return
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  log "Installing shell theme and plugins"
  clone_or_update https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
  clone_or_update https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"
}

install_powerlevel10k_gitstatus() {
  if [[ "$SKIP_EXTERNAL_INSTALLS" -eq 1 ]]; then
    return
  fi

  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local gitstatus_dir="$zsh_custom/themes/powerlevel10k/gitstatus"
  local gitstatus_install="$gitstatus_dir/install"

  if [[ ! -x "$gitstatus_install" ]]; then
    warn "powerlevel10k gitstatus installer not found; skipping gitstatus bootstrap"
    return
  fi

  log "Bootstrapping powerlevel10k gitstatus"
  if ! HOME="$HOME" sh "$gitstatus_install" -d "$gitstatus_dir" >/dev/null; then
    warn "Failed to bootstrap powerlevel10k gitstatus; first interactive zsh start may retry"
  fi
}

install_tmux_tpm() {
  if [[ "$SKIP_EXTERNAL_INSTALLS" -eq 1 ]]; then
    return
  fi

  log "Installing tmux TPM"
  clone_or_update https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

install_optional_toolchains() {
  if [[ "$SKIP_OPTIONAL_TOOLCHAINS" -eq 1 ]]; then
    return
  fi

  if ! has_cmd curl; then
    warn "curl is required for optional toolchain installers"
    return
  fi

  if ! has_cmd bun; then
    log "Installing Bun"
    curl -fsSL https://bun.sh/install | bash
  fi

  if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
    log "Installing nvm"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  fi

  if ! has_cmd rustup; then
    log "Installing rustup"
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
  fi

  if ! has_cmd gitnexus; then
    if has_cmd npm; then
      log "Installing gitnexus"
      npm install -g gitnexus
    else
      warn "npm is not installed; skipping gitnexus installation"
    fi
  fi
}

set_default_shell() {
  if [[ "$SKIP_EXTERNAL_INSTALLS" -eq 1 ]]; then
    return
  fi

  if ! has_cmd zsh; then
    warn "zsh is not installed; skipping default shell update"
    return
  fi

  if [[ "${SHELL:-}" == *"zsh" ]]; then
    return
  fi

  if has_cmd chsh; then
    log "Setting default shell to zsh"
    chsh -s "$(command -v zsh)" || warn "Failed to change default shell automatically"
  fi
}

link_dotfiles() {
  log "Linking dotfiles from $DOTFILES_ROOT"

  link "$DOTFILES_ROOT/.gitconfig" "$HOME/.gitconfig"
  link "$DOTFILES_ROOT/.gitignore_global" "$HOME/.gitignore_global"
  link "$DOTFILES_ROOT/.bashrc" "$HOME/.bashrc"
  link "$DOTFILES_ROOT/.zshrc" "$HOME/.zshrc"
  link "$DOTFILES_ROOT/.p10k.zsh" "$HOME/.p10k.zsh"
  link "$DOTFILES_ROOT/.tmux.conf" "$HOME/.tmux.conf"

  log "Linking config directories"
  link "$DOTFILES_ROOT/config/ghostty" "$HOME/.config/ghostty"
  link "$DOTFILES_ROOT/config/nvim" "$HOME/.config/nvim"

  log "Linking git hooks"
  link "$DOTFILES_ROOT/hooks" "$HOME/.git-hooks"

  log "Setting up git profile"
  if [[ ! -L "$HOME/.gitconfig.profile" ]]; then
    local default_profile="$DOTFILES_ROOT/gitconfig/work"
    if [[ -f "$default_profile" ]]; then
      ln -sfn "$default_profile" "$HOME/.gitconfig.profile"
      printf '  Default git profile set to: work\n'
    fi
  fi
}

link_launchd_agents() {
  log "Linking launchd agents"

  local plist
  for plist in "$DOTFILES_ROOT/launchd"/*.plist; do
    [[ -f "$plist" ]] || continue
    local name
    name="$(basename "$plist")"
    link "$plist" "$HOME/Library/LaunchAgents/$name"
    if launchctl list "$name" &>/dev/null; then
      launchctl unload "$HOME/Library/LaunchAgents/$name" 2>/dev/null || true
    fi
    launchctl load "$HOME/Library/LaunchAgents/$name"
  done
}

link_bin_scripts() {
  log "Linking bin scripts to ~/.local/bin"
  mkdir -p "$HOME/.local/bin"

  local script
  for script in "$DOTFILES_ROOT/bin"/*; do
    [[ -f "$script" ]] || continue
    local name
    name="$(basename "$script")"
    chmod +x "$script"
    link "$script" "$HOME/.local/bin/$name"
  done
}

install_core_packages
install_oh_my_zsh
install_shell_plugins
install_powerlevel10k_gitstatus
install_tmux_tpm
install_optional_toolchains
link_dotfiles
link_bin_scripts
link_launchd_agents
set_default_shell

log "Done"
