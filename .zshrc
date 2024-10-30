eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/fnm env --use-on-cd)"

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

antigen theme spaceship-prompt/spaceship-prompt

# Apply
antigen apply

# Make sure wp-cli autocompletion works
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

for file in ~/.{exports,aliases,functions,spaceshiprc}; do
    [ -r "$file" ] && source "$file"
done
unset file

for file in $HOME/.dotfiles/includes/*;
  do source $file
done
unset file

# Added by `rbenv init` on Tue Oct 29 22:38:39 CET 2024
eval "$(rbenv init - --no-rehash zsh)"
