eval "$(fnm env)"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f6370"

# Load Antigen (`brew install antigen`)
source /opt/homebrew/share/antigen/antigen.zsh

# Use oh-my-zsh
antigen use oh-my-zsh

# Plugins
antigen bundle extract
antigen bundle z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle wp-cli
antigen theme spaceship-prompt/spaceship-prompt

# Apply
antigen apply

autoload -U mmv

# Make sure wp-cli autocompletion works
# https://github.com/wp-cli/wp-cli/tree/v2.4.1#tab-completions
autoload bashcompinit
bashcompinit

# Load .dotfiles
for file in ~/.{exports,aliases,functions,antigenrc,spaceshiprc}; do
    [ -r "$file" ] && source "$file"
done
unset file

for file in $HOME/.dotfiles/includes/*;
  do source $file
done
unset file
