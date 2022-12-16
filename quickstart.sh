#!/bin/bash

# Requesh priviledge
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Setup Finder Commands
# Show Library Folder in Finder
echo "Setting finder settings"
chflags nohidden ~/Library

# Show Hidden Files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew installed successfully"
else
    echo "Homebrew already installed!"
fi

# Install XCode Command Line Tools
echo 'Checking to see if XCode Command Line Tools are installed'
brew config

# Updating Homebrew.
echo "Updating Homebrew"
brew update

# Upgrade any already-installed formulae.
echo "Upgrading Homebrew"
brew upgrade

# Download application list from GitHub
echo "Pulling applist"
curl https://raw.githubusercontent.com/username/repository/master/applist.txt -o applist.txt

# Install Applications
while read -r app; do
    if [[ "$app" == *"cask"* ]]; then
        # Install cask application
        brew cask install "${app#*cask:}"
    else
        # Install non-cask application
        brew install "$app"
    fi
done < applist.txt

# Remove the local copy of the application list
rm applist.txt
----

# Install iTerm2
echo "Installing iTerm2..."
brew cask install iterm2

# Update the Terminal
# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Need to logout now to start the new SHELL..."
logout

# Install Git
echo "Installing Git..."
brew install git

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git
cd fonts || exit
sh -c ./install.sh

# Install ruby
if test ! "$(which ruby)"; then
    echo "Installing Ruby..."
    brew install ruby
    echo "Adding the brew ruby path to shell config..."
    echo 'export PATH='"/usr/local/opt/ruby/bin:$PATH" >>~/.bash_profile
else
    echo "Ruby already installed!"
fi

# Remove outdated versions from the cellar.
echo "Running brew cleanup..."
brew cleanup
echo "You're done!"
