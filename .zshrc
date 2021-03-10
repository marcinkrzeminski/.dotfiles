# Load Antigen (`brew install antigen`)
source /usr/local/share/antigen/antigen.zsh

# Include .dotfiles
for file in ~/.{exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# Spaceship Prompt Settings
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_PACKAGE_SHOW=false

ZSH_THEME="honukai"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5f6370"

###############################################################################
# ATINGEN
###############################################################################

# Use oh-my-zsh
antigen use oh-my-zsh

# Plugins
antigen bundle extract
antigen bundle z
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle lukechilds/zsh-nvm
# antigen bundle Sparragus/zsh-auto-nvm-use
# antigen bundle command-not-found
antigen bundle wp-cli

# Themes
# antigen theme robbyrussell

# Apply
antigen apply

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship
