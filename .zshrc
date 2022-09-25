# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
eval "$(fnm env)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f6370"
ZSH_DISABLE_COMPFIX=true

# Load Antigen (`brew install antigen`)
source /opt/homebrew/share/antigen/antigen.zsh

# Use oh-my-zsh
antigen use oh-my-zsh

# Plugins
antigen bundle extract
antigen bundle z
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle npm
antigen bundle yarn

antigen theme spaceship-prompt/spaceship-prompt

# Apply
antigen apply

autoload -U mmv

# Make sure wp-cli autocompletion works
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Load .dotfiles
for file in ~/.{exports,aliases,functions,antigenrc,spaceshiprc}; do
    [ -r "$file" ] && source "$file"
done
unset file

for file in $HOME/.dotfiles/includes/*;
  do source $file
done
unset file

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
