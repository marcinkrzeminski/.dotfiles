# Create symlinks
echo "Creating symlinks ..."
dotfiles=(
    .aliases
    .exports
    .functions
    .gitconfig
    .gitignore_global
    .hushlogin
    .macos
    .spaceshiprc
    .zshrc
    .mackup.cfg
)
for file in "${dotfiles[@]}"; do
    ln -sf $HOME/.dotfiles/$file $HOME/$file
done
unset file

ln -sf $HOME/.dotfiles/Brewfile $HOME/Brewfile

# Install Homebrew
echo "Installing brew ..."
if test ! $(which brew)
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install brew packages
echo "Installing brew bundles ..."
brew bundle

# Run Brew Cleanup
brew cleanup

# Install global npm packages
echo "Installing npm packages ..."
pnpm add -g broken-link-checker
pnpm add -g prettier
pnpm add -g trash-cli
pnpm add -g generator-chisel@next

# Fix insecure directories for ZSH
compaudit | xargs chmod g-w

# Remove all apps from dock
dockutil --remove all --no-restart

# Add some apps to dock
dockutil --add /Applications/Visual\ Studio\ Code.app --no-restart
dockutil --add /Applications/PhpStorm.app --no-restart
dockutil --add /Applications/Arc.app --no-restart
dockutil --add /Applications/iTerm.app

# Install wp-cli autocompletions
cd $HOME/.dotfiles/includes
WP_CLI_VERSION=$(sed "s/WP-CLI //" <<< $(wp --version))
wget https://raw.githubusercontent.com/wp-cli/wp-cli/$WP_CLI_VERSION/utils/wp-completion.bash

# Run macOS setup
source .macos

# restore apps settings via mackup
mackup restore

# install Laravel Valet
composer global require laravel/valet
valet install
