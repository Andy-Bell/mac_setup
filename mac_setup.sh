#!/bin/bash
set -ex

install_encryptme() {
    if [ ! -d /Applications/EncryptMe.app ]
    then
        curl -L 'https://app.encrypt.me/transition/download/osx/latest/' > /tmp/encryptme.dmg
        sudo hdiutil attach -nobrowse /tmp/encryptme.dmg
        cp -r /Volumes/EncryptMe/EncryptMe.app /Volumes/EncryptMe/Applications
        sudo hdiutil unattach /Volumes/EncryptMe
    fi
}

install_mac_apps() {
    if [ ! -f ~/.apps_installed ]
    then
        curl -s 'https://macapps.link/en/firefoxdev-alfred-docker-iterm-1password-spotify-thunderbird-slack-vscode' | sh
    fi
}

activate_xcode() {
    sudo xcodebuild -license
    git
}

brew_install_the_universe() {
    if [ ! -f /usr/local/bin/brew ]
    then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    formulas="chruby wget ruby-install hub direnv redis python3 redis ctags jq watch imagemagick selecta htop vim cmake automake libtool tig tmux zsh zsh-completions"
    for formula in $formulas
    do
        brew install $formula || brew upgrade $formula
    done
}

install_rubies() {
    ruby-install ruby 2.5
    ruby-install ruby 2.2.6
    ruby-install ruby 2.2.7
    ruby-install ruby 2.3
    ruby-install ruby 2.4
}

write_defaults() {
    # screenshot location
    defaults write com.apple.screencapture location $HOME/screenshots

    # no key chooser, prefering repeats instead
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
}

install_rustup() {
    if [[ -z `which rustup` ]]
    then
        curl https://sh.rustup.rs -sSf | sh
    fi
}

install_node() {
    if [[ -z `command -v nvm` ]]
    then
        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    fi
}

install_powerline_fonts() {
    if [ ! -d ~/.fonts ]
    then
        # clone
        git clone https://github.com/powerline/fonts.git ~/.fonts --depth=1
        # install
        cd .fonts
        ./install.sh
        # clean-up a bit
        cd ..
    fi
}

install_encryptme
install_mac_apps
brew_install_the_universe
install_rubies
write_defaults
install_rustup
install_node
install_powerline_fonts

mkdir -p ~/dev

if [ ! -d ~/.dotfiles ]
then
    git clone git@github.com:andy-bell/dotfiles ~/.dotfiles
    cd ~/.dotfiles && rake install
fi
echo "now log off"

