#!/bin/bash

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Download application list from GitHub
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
