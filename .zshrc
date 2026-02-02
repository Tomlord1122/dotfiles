
export ZSH="$HOME/.oh-my-zsh"

## add plugin at this line
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Add Homebrew zsh completions to FPATH
if type brew &>/dev/null; then
 FPATH="$(brew --prefix)/share/zsh-completions:$FPATH"
fi

source $ZSH/oh-my-zsh.sh

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# some more handy aliases
alias cl='clear'
alias la='ls -A'
alias grep='grep --color=auto'
alias gos="go-symphony create -a"
alias gc="git commit -s -m"
alias gn="git pull upstream"
alias gm="git merge --no-ff"
alias gocache="go clean -cache -modcache"
alias oc="opencode"
alias c="open  -a "Cursor""
export PATH="$HOME/go/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.govm/shim:$PATH"
export PATH="$HOME/go/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export GOPRIVATE=github.trendmicro.com,adc.github.trendmicro.com
