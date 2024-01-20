eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/opt/homebrew/bin/fnm env --use-on-cd)"

# Load Antigen
source /opt/homebrew/share/antigen/antigen.zsh

# Use oh-my-zsh
antigen use oh-my-zsh

# Plugins
antigen bundle extract
antigen bundle z
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

for file in ~/.{exports,aliases,functions,antigenrc,spaceshiprc}; do
    [ -r "$file" ] && source "$file"
done
unset file

for file in $HOME/.dotfiles/includes/*;
  do source $file
done
unset file

# export PATH="/Users/marcin/homebrew/opt/ruby/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# bun completions
[ -s "/Users/marcin/.bun/_bun" ] && source "/Users/marcin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
