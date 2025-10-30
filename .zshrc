# Cache brew shellenv (regenerate: rm ~/.brew_shellenv_cache)
if [[ ! -f ~/.brew_shellenv_cache ]] || [[ /opt/homebrew/bin/brew -nt ~/.brew_shellenv_cache ]]; then
    /opt/homebrew/bin/brew shellenv > ~/.brew_shellenv_cache
fi
source ~/.brew_shellenv_cache

# Performance: Enable antigen caching (must be before loading antigen)
export ANTIGEN_CACHE=true
export ZSH_DISABLE_COMPFIX=true
export skip_global_compinit=1

# Load Antigen
source /opt/homebrew/share/antigen/antigen.zsh

# Use oh-my-zsh
antigen use oh-my-zsh

# Plugins
antigen bundle extract
antigen bundle git
antigen bundle z
antigen bundle fzf
antigen bundle wp-cli
antigen bundle macos
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# Theme - skip in Warp, load Spaceship elsewhere
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  antigen theme spaceship-prompt/spaceship-prompt
fi

# Apply
antigen apply

# Completions - Docker
fpath=(/Users/marcin/.docker/completions $fpath)
autoload -U +X bashcompinit && bashcompinit

# Source dotfiles
for file in ~/.{exports,aliases,functions,spaceshiprc}; do
    [ -r "$file" ] && source "$file"
done
unset file

for file in $HOME/.dotfiles/includes/*; do
    source $file
done
unset file

# PATH exports (all at once, avoid duplicates)
export PNPM_HOME="/Users/marcin/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# Build PATH once
typeset -U path  # ensure unique entries
path=(
    $HOME/.composer/vendor/bin
    $HOME/homebrew/bin
    $HOME/homebrew/opt/mariadb/bin
    $BUN_INSTALL/bin
    $PNPM_HOME
    /Applications/PhpStorm.app/Contents/MacOS
    ~/.docker/bin
    $HOME/.local/bin
    /opt/homebrew/opt/openjdk@17/bin
    /opt/homebrew/opt/ruby/bin
    /Users/marcin/.codeium/windsurf/bin
    $path
)

# Aliases
alias pip=pip3
alias tm='task-master'
alias taskmaster='task-master'

# Lazy load FNM - only initialize when needed
function node() {
  unfunction node npm npx pnpm
  eval "$(/opt/homebrew/bin/fnm env --use-on-cd)"
  $0 "$@"
}
function npm() { node; }
function npx() { node; }
function pnpm() { node; }

# Warp prompt override
if [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
  PROMPT='%F{cyan}%~%f %F{green}➜%f '
fi

# Atuin shell history
eval "$(atuin init zsh --disable-up-arrow)"
