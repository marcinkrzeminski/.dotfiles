# Create symlinks
echo "Creating symlinks ..."
for file in .{aliases,exports,functions,gitconfig,gitignore_global,hushlogin,macos,zshrc}; do
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
npm i -g @wordpress/env
npm i -g spaceship-prompt
npm i -g broken-link-checker
npm i -g lighthouse
npm i -g prettier
npm i -g trash-cli
npm i -g generator-chisel@next

# install ZSH theme
mkdir -p $HOME/.oh-my-zsh/custom/themes/
cp prefs/honukai.zsh-theme $HOME/.oh-my-zsh/custom/themes/

# Fix insecure directories for ZSH
compaudit | xargs chmod g-w

# Remove all apps from dock
dockutil --remove all --no-restart

# Add some apps to dock
dockutil --add /Applications/Visual\ Studio\ Code.app --no-restart
dockutil --add /Applications/PhpStorm.app --no-restart
dockutil --add /Applications/Brave\ Browser.app --no-restart
dockutil --add /Applications/iTerm.app

echo "Need to log in to App Store manually to install apps with mas...." $red
echo "Opening App Store. Please login."
open "/Applications/App \Store.app"
echo "Is app store login complete.(y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ]
then
    mas install 937984704 # Amphetamine
    mas install 425264550 # Disk Speed Test
    mas install 682658836 # GarageBand
    mas install 408981434 # iMovie
    mas install 409183694 # Keynote
    # mas install 926036361 # LastPass
    mas install 409203825 # Numbers
    mas install 409201541 # Pages
    mas install 497799835 # Xcode
else
	cecho "App Store login not complete. Skipping installing App Store Apps" $red
fi

# Run macOS setup
source .macos
