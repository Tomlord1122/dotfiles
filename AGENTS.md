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

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **dotfiles** (59 symbols, 52 relationships, 0 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `node .gitnexus/run.cjs analyze` from the project root — it auto-selects an available runner. No `.gitnexus/run.cjs` yet? `npx gitnexus analyze` (npm 11 crash → `npm i -g gitnexus`; #1939).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({search_query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.
- For security review, `explain({target: "fileOrSymbol"})` lists taint findings (source→sink flows; needs `analyze --pdg`).

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/dotfiles/context` | Codebase overview, check index freshness |
| `gitnexus://repo/dotfiles/clusters` | All functional areas |
| `gitnexus://repo/dotfiles/processes` | All execution flows |
| `gitnexus://repo/dotfiles/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
