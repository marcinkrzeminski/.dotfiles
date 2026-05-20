# Cache brew shellenv (regenerate: rm ~/.brew_shellenv_cache)
if [[ ! -f ~/.brew_shellenv_cache ]] || [[ /opt/homebrew/bin/brew -nt ~/.brew_shellenv_cache ]]; then
    /opt/homebrew/bin/brew shellenv > ~/.brew_shellenv_cache
fi
source ~/.brew_shellenv_cache

# Performance settings
export ZSH_DISABLE_COMPFIX=true

# Shell options
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # push directories to stack
setopt PUSHD_IGNORE_DUPS    # no duplicates in dir stack
setopt PUSHD_SILENT         # don't print stack after pushd/popd

# ============================================
# Plugin paths
# ============================================
_omz="$HOME/.antigen/bundles/robbyrussell/oh-my-zsh"
_plugins="$HOME/.antigen/bundles/zsh-users"

# ============================================
# Completions (must be before plugins using compdef)
# ============================================
fpath=(
    $_plugins/zsh-completions/src
    /Users/marcin/.docker/completions
    $fpath
)
# Guard: only run compinit once per session.
# Re-sourcing .zshrc after plugins are loaded causes compdump to build a
# huge alternation pattern (~600+ _* functions) that exceeds zsh's limit.
if [[ -z $_zshrc_compinit_loaded ]]; then
    autoload -Uz compinit
    setopt EXTENDED_GLOB  # required for (N.mh+24) file-age check
    if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
        compinit
    else
        compinit -C
    fi
    autoload -U +X bashcompinit && bashcompinit
    _zshrc_compinit_loaded=1
fi

# ============================================
# Oh-My-Zsh libs & plugins
# ============================================
source "$_omz/lib/directories.zsh"
source "$_omz/lib/git.zsh"
source "$_omz/lib/key-bindings.zsh"
source "$_omz/lib/history.zsh"

source "$_omz/plugins/git/git.plugin.zsh"
source "$_omz/plugins/z/z.plugin.zsh"
source "$_omz/plugins/extract/extract.plugin.zsh"
[[ -f "$_omz/plugins/fzf/fzf.plugin.zsh" ]] && source "$_omz/plugins/fzf/fzf.plugin.zsh"

# External plugins
source "$_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"  # Must be last

# Spaceship prompt (skip in Warp)
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    source "$HOME/.antigen/bundles/spaceship-prompt/spaceship-prompt/spaceship.zsh"
fi

# Source dotfiles
for file in ~/.{exports,functions,spaceshiprc,aliases}; do
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
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"

# mise activate must run BEFORE PATH array build so our explicit entries win.
# Binary path defined below; reuse same path here.
_mise_bin="/opt/homebrew/bin/mise"
[[ -x "$_mise_bin" ]] && eval "$($_mise_bin activate zsh)"

# Build PATH once
typeset -U path  # ensure unique entries
path=(
    $HOME/.composer/vendor/bin
    $HOME/.antigravity/antigravity/bin
    $HOME/.opencode/bin
    $BUN_INSTALL/bin
    $PNPM_HOME
    $HOME/.local/bin
    /opt/homebrew/opt/openjdk@21/bin
    /Users/marcin/.codeium/windsurf/bin
    $path
)

# Ensure cache directory exists (once)
[[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"

# Binary paths for cache invalidation (avoids subprocess calls)
_fnm_bin="/opt/homebrew/bin/fnm"
_atuin_bin="/opt/homebrew/bin/atuin"
_direnv_bin="/opt/homebrew/bin/direnv"
_mise_bin="/opt/homebrew/bin/mise"
_scw_bin="/opt/homebrew/bin/scw"
_rbenv_bin="/opt/homebrew/bin/rbenv"
# Note: openclaw path is dynamic (fnm), cache manually with: rm ~/.cache/openclaw_completion.zsh

# FNM - must be dynamic (creates per-session paths, cannot be cached)
[[ -x "$_fnm_bin" ]] && eval "$($_fnm_bin env --use-on-cd)"

# Warp prompt override
[[ $TERM_PROGRAM == "WarpTerminal" ]] && PROMPT='%F{cyan}%~%f %F{green}➜%f '

# Atuin shell history
_atuin_cache="$HOME/.cache/atuin_init.zsh"
[[ -x "$_atuin_bin" && (! -f "$_atuin_cache" || "$_atuin_bin" -nt "$_atuin_cache") ]] && "$_atuin_bin" init zsh --disable-up-arrow > "$_atuin_cache" 2>/dev/null
[[ -f "$_atuin_cache" ]] && source "$_atuin_cache"

# direnv hook
_direnv_cache="$HOME/.cache/direnv_init.zsh"
[[ -x "$_direnv_bin" && (! -f "$_direnv_cache" || "$_direnv_bin" -nt "$_direnv_cache") ]] && "$_direnv_bin" hook zsh > "$_direnv_cache" 2>/dev/null
[[ -f "$_direnv_cache" ]] && source "$_direnv_cache"

# rbenv init (cached, regenerate: rm ~/.cache/rbenv_init.zsh)
_rbenv_cache="$HOME/.cache/rbenv_init.zsh"
[[ -x "$_rbenv_bin" && (! -f "$_rbenv_cache" || "$_rbenv_bin" -nt "$_rbenv_cache") ]] && "$_rbenv_bin" init - zsh > "$_rbenv_cache" 2>/dev/null
[[ -f "$_rbenv_cache" ]] && source "$_rbenv_cache"

# Scaleway CLI autocomplete
_scw_cache="$HOME/.cache/scw_completion.zsh"
[[ -x "$_scw_bin" && (! -f "$_scw_cache" || "$_scw_bin" -nt "$_scw_cache") ]] && "$_scw_bin" autocomplete script shell=zsh > "$_scw_cache" 2>/dev/null
[[ -f "$_scw_cache" ]] && source "$_scw_cache"

# OpenClaw Completion (regenerate: rm ~/.cache/openclaw_completion.zsh)
_openclaw_cache="$HOME/.cache/openclaw_completion.zsh"
if [[ ! -f "$_openclaw_cache" ]]; then
  openclaw completion --shell zsh > "$_openclaw_cache" 2>/dev/null
fi
[[ -f "$_openclaw_cache" ]] && source "$_openclaw_cache"

# Pi coding agent update alias
alias pi-update="npm install -g @earendil-works/pi-coding-agent"

# bun completions
[ -s "/Users/marcin/.bun/_bun" ] && source "/Users/marcin/.bun/_bun"
