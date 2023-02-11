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

# Show /Library
chflags nohidden ~/Library

# Show /Volumes
sudo chflags nohidden /Volumes

# Show Filename Extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Set Downloads as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
echo "Pulling Applist"
curl https://github.com/AngelaDMerkel/macos-quick-setup/blob/af95b06e79d437bf29244954fa78322ae56a1af4/Brewfile -o Brewfile

# Install Applications
echo "Installing Apps"
brew bundle --file=Brewfile

# Remove the local copy of the application list
rm Brewfile

# Remove outdated versions from the cellar.
echo "Cleanup"
brew cleanup
echo "Done"
