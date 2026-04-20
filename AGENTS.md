# AGENTS.md

## Repo Scope

- This repo is a small dotfiles repo, not a general app workspace. The only managed targets verified by `install.sh` are `.gitconfig`, `.bashrc`, `.zshrc`, `.p10k.zsh`, `.tmux.conf`, `config/ghostty`, and `config/nvim`.
- Treat `install.sh` as the source of truth for setup behavior. `README.md` is a quick-start summary, but the script defines the real install order, flags, package list, and linked paths.

## Install Flow

- Main bootstrap command: `./install.sh`
- Safe relink-only command when you only changed repo files: `./install.sh --link-only`
- Other supported flags: `./install.sh --skip-packages`, `./install.sh --skip-optional-toolchains`
- `--link-only` also skips external installs like `oh-my-zsh`, TPM, and shell plugins by setting an internal `SKIP_EXTERNAL_INSTALLS=1`. If you are only editing dotfiles, prefer this mode for verification.
- The script backs up existing real files and directories to `*.bak.<timestamp>` before replacing them. Do not add alternate backup logic elsewhere unless asked.

## Platform Details

- macOS package installs use Homebrew and will auto-install Homebrew if missing.
- Linux package installs prefer `apt-get`; if unavailable, the script falls back to Homebrew.
- Linux installs `fd-find`, not `fd`. Keep that distinction if you touch package lists.
- Optional toolchains installed by the script are `bun`, `nvm`, and `rustup`.

## Neovim

- Neovim config is a LazyVim-based setup under `config/nvim`.
- Entry point is `config/nvim/init.lua`, which only loads `config.lazy`; plugin wiring lives under `config/nvim/lua/plugins/*.lua`.
- Add new plugins as dedicated files in `config/nvim/lua/plugins/` instead of editing `example.lua`. That file is explicitly disabled with `if true then return {} end` and is only a template.
- LazyVim extras enabled by this repo are defined in `config/nvim/lazyvim.json`; plugin pinning is in `config/nvim/lazy-lock.json`.
- If you intentionally change plugin versions or add a plugin that updates the lockfile, keep `lazy-lock.json` in sync rather than leaving a half-updated plugin set.

## Shell Config

- Keep the Powerlevel10k instant prompt block near the top of `.zshrc`; the file explicitly warns that interactive init code must stay above it.
- `.zshrc` manually sources `zsh-autosuggestions` and `zsh-syntax-highlighting` from either `oh-my-zsh` custom dirs or Homebrew paths. Do not assume OMZ plugin declarations alone are enough here.

## Maintenance Guidance

- Prefer editing repo files, then verifying with `./install.sh --link-only`, because `$HOME` is updated via symlinks from this repo.
- When changing `install.sh`, preserve the current execution order: core packages -> oh-my-zsh -> shell plugins -> tmux TPM -> optional toolchains -> symlinks -> default shell.
- Keep changes minimal and target the managed files only. Avoid adding machine-specific paths, secrets, or host-only state to tracked dotfiles.
- For Neovim changes, keep repo-specific customization in `lua/plugins/`, `lua/config/keymaps.lua`, `lua/config/options.lua`, and `lua/config/autocmds.lua` instead of modifying generated or upstream-managed areas.
