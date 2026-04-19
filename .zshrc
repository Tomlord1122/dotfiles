# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

## add plugin at this line
plugins=(git)

# Add Homebrew zsh completions to FPATH when available.
if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
  fi
fi

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

if [[ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ -n "${HOMEBREW_PREFIX:-}" && -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -n "${HOMEBREW_PREFIX:-}" && -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# some more handy aliases
th() {
  cat <<'EOF'
TMUX QUICK REFERENCE
--------------------
Sessions:
  tmux                        Start a new unnamed session
  tmux new -s <name>          Start a new named session
  tmux ls                     List all sessions
  tmux a                      Attach to the last session
  tmux a -t <name>            Attach to a named session
  tmux rename-session <name>  Rename current session (from outside)
  tmux kill-session -t <name> Kill a named session
  tmux kill-server            Kill all sessions

Inside tmux (prefix = Ctrl+b):
  prefix + $                  Rename current session
  prefix + d                  Detach from session
  prefix + s                  Show session list (interactive)
  prefix + c                  New window
  prefix + ,                  Rename current window
  prefix + n / p              Next / previous window
  prefix + |                  Split pane vertically   (custom)
  prefix + -                  Split pane horizontally (custom)
  prefix + arrow keys         Navigate between panes
  prefix + z                  Toggle pane zoom (fullscreen)
  prefix + [                  Enter copy/scroll mode (q to quit)
  prefix + y                  Open yazi in split pane (custom)
--------------------
EOF
}

kh() {
  cat <<'EOF'
KUBECTL QUICK REFERENCE
-----------------------
Context and namespace:
  kubectl config get-contexts                 List contexts
  kubectl config current-context              Show current context
  kubectl config use-context <name>           Switch context
  kubectl config set-context --current --namespace=<ns>  Set current namespace

Inspect resources:
  kubectl get ns                              List namespaces
  kubectl get pods -A                         List all pods
  kubectl get svc -A                          List all services
  kubectl get deploy -A                       List all deployments
  kubectl get pod <pod> -n <ns> -o wide      Pod details with node/IP
  kubectl describe pod <pod> -n <ns>          Detailed pod status/events

Logs and debugging:
  kubectl logs <pod> -n <ns>                  Pod logs
  kubectl logs -f <pod> -n <ns>               Follow logs
  kubectl logs <pod> -c <container> -n <ns>  Logs for specific container
  kubectl exec -it <pod> -n <ns> -- sh        Exec into pod
  kubectl port-forward svc/<name> 8080:80 -n <ns>  Port-forward service

Rollouts and changes:
  kubectl apply -f <file.yaml>                Apply manifest
  kubectl delete -f <file.yaml>               Delete manifest
  kubectl rollout status deploy/<name> -n <ns>   Watch rollout
  kubectl rollout restart deploy/<name> -n <ns>  Restart deployment
  kubectl rollout undo deploy/<name> -n <ns>     Rollback deployment

Handy one-liners:
  kubectl get events -n <ns> --sort-by=.metadata.creationTimestamp
  kubectl top pod -n <ns>                     Pod CPU/memory (metrics-server)
-----------------------
EOF
}

ah() {
  cat <<'EOF'
AWS CLI QUICK REFERENCE
-----------------------
Setup and identity:
  aws configure                               Configure default profile
  aws configure list                          Show active config values
  aws sts get-caller-identity                 Verify account/role in use
  aws configure sso                           Configure AWS IAM Identity Center

Profiles and regions:
  aws configure list-profiles                 List named profiles
  aws s3 ls --profile <profile>               Run command with profile
  aws ec2 describe-regions --query 'Regions[].RegionName' --output text

EC2:
  aws ec2 describe-instances                  List instances
  aws ec2 describe-instances --filters Name=instance-state-name,Values=running
  aws ec2 describe-security-groups            List security groups

CloudWatch logs:
  aws logs describe-log-groups                List log groups
  aws logs tail /aws/lambda/<fn> --since 1h --follow

S3:
  aws s3 ls                                   List buckets
  aws s3 ls s3://<bucket>/                    List objects
  aws s3 cp <local-file> s3://<bucket>/<key> Upload file
  aws s3 cp s3://<bucket>/<key> <local-file> Download file
  aws s3 sync <local-dir> s3://<bucket>/      Sync directory up

EKS and ECR:
  aws eks list-clusters                       List EKS clusters
  aws eks update-kubeconfig --name <cluster> --region <region>
  aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <acct>.dkr.ecr.<region>.amazonaws.com

Safer defaults:
  aws <service> <operation> --dry-run         Simulate (where supported)
  aws <service> <operation> --no-cli-pager    Disable pager for command
-----------------------
EOF
}

hh() {
  cat <<'EOF'
HELM QUICK REFERENCE
--------------------
Repos and search:
  helm repo list                             List repos
  helm repo add <name> <url>                 Add chart repo
  helm repo update                            Refresh repo index
  helm search repo <keyword>                  Search charts in repos

Inspect charts:
  helm show values <repo/chart>               Show chart defaults
  helm show chart <repo/chart>                Show chart metadata
  helm pull <repo/chart> --untar              Download and extract chart

Install and upgrade:
  helm install <release> <repo/chart> -n <ns> --create-namespace
  helm upgrade <release> <repo/chart> -n <ns> -f values.yaml
  helm upgrade --install <release> <repo/chart> -n <ns> -f values.yaml
  helm upgrade <release> <repo/chart> -n <ns> --dry-run --debug

Release management:
  helm list -A                                List releases all namespaces
  helm status <release> -n <ns>               Release status
  helm history <release> -n <ns>              Release revisions
  helm rollback <release> <revision> -n <ns>  Roll back release
  helm uninstall <release> -n <ns>            Remove release

Templating and lint:
  helm lint <chart-dir>                       Lint chart
  helm template <release> <chart-dir> -n <ns> -f values.yaml
  helm get values <release> -n <ns>           Get user-supplied values
  helm get manifest <release> -n <ns>         Rendered manifests from cluster
--------------------
EOF
}

hfh() {
  cat <<'EOF'
HELMFILE QUICK REFERENCE
------------------------
Basics:
  helmfile list                               List releases from helmfile
  helmfile deps                               Build/download chart dependencies
  helmfile lint                               Lint all releases
  helmfile diff                               Show what would change
  helmfile apply                              Diff then sync changes
  helmfile sync                               Apply desired state directly
  helmfile destroy                            Delete all managed releases

Environment and selectors:
  helmfile -e <env> list                      Use environment from helmfile
  helmfile -e <env> diff                      Diff for one environment
  helmfile -l app=<name> diff                 Target releases by label
  helmfile -l app=<name> apply                Apply selected releases

Templating and debugging:
  helmfile template                           Render manifests locally
  helmfile build                              Build merged state output
  helmfile write-values                       Generate values files
  helmfile --log-level debug diff             Verbose debug logs

Safer workflow:
  helmfile -e <env> diff                      Review first
  helmfile -e <env> apply                     Apply reviewed changes
------------------------
EOF
}

alias cl='clear'
alias la='ls -A'
alias grep='grep --color=auto'
alias gos="go-symphony create -a"
alias gc="git commit -s -m"
alias gn="git pull upstream"
alias gocache="go clean -cache -modcache"
alias oc="opencode"
alias t='tmux a'
alias vim='nvim'

if command -v cursor >/dev/null 2>&1; then
  alias c='cursor'
elif command -v open >/dev/null 2>&1; then
  alias c='open -a "Cursor"'
fi

export PATH="$HOME/go/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
if [[ -z "${PNPM_HOME:-}" ]]; then
  if [[ -d "$HOME/Library/pnpm" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
  elif [[ -n "${XDG_DATA_HOME:-}" ]]; then
    export PNPM_HOME="$XDG_DATA_HOME/pnpm"
  else
    export PNPM_HOME="$HOME/.local/share/pnpm"
  fi
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export GOPRIVATE=github.trendmicro.com,adc.github.trendmicro.com

if [[ -f "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"
elif [[ -n "${HOMEBREW_PREFIX:-}" && -f "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
