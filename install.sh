#!/bin/bash

# Git config
if test ! -f ~/.gitignore_global; then
  cp git/.gitconfig ~/.gitconfig
  cp git/.gitignore_global ~/.gitignore_global
  cp -R git/.git_template ~/.git_template
fi

# Tools
printf "Updating repositories and installing basic tools\n"
sudo apt update
sudo apt install -y vim wget curl make xclip htop jq resolvconf htop autojump fzf build-essential zsh shellcheck vlc bat openvpn

# Go
if test ! -d /usr/local/go; then
  printf "Installing Go\n"
  curl -O https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
  tar xvf go1*.tar.gz
  sudo chown -R root:root ./go
  sudo mv go /usr/local
  rm go1*.tar.gz
fi

# Fuzzy search
if test ! -f /bin/fzf; then
  printf "Installing fzf\n"
  git clone https://github.com/junegunn/fzf.git /tmp/fzf
  /tmp/fzf/install
fi

# Docker
if test ! -f /usr/bin/docker; then
  printf "Installing Docker\n"
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu eoan stable"
  sudo apt update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-ce
  sudo groupadd docker
  sudo usermod -aG docker "${USER}"
  newgrp docker
fi

# Chrome
if ! dpkg -s google-chrome-stable; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm google-chrome-stable_current_amd64.deb
fi

# Spotify
if ! find /etc/apt/ -name "*.list" | xargs cat | grep "spotify"; then
  printf "Installing Spotify\n"
  curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
  sudo apt update
  sudo apt install -y spotify-client
fi

# Telegram
if ! find /etc/apt/ -name "*.list" | xargs cat | grep "telegram"; then
  printf "Installing Telegram\n"
  sudo add-apt-repository -y ppa:atareao/telegram
  sudo apt update
  sudo apt install -y telegram
  sudo chown -R "${USER}":"${USER}" /opt/telegram
fi

# Slack
if ! dpkg -s slack-desktop; then
  printf "Installing Slack\n"
  wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb
  sudo apt install -y ./slack-desktop-*.deb
  rm slack-desktop-*.deb
fi

# Kubectl
if test ! -f /usr/local/bin/kubectl; then
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
fi

# Go libraries
export GOPRIVATE="github.com/giantswarm/opsctl"
GO111MODULE="on" go get sigs.k8s.io/kind@v0.8.0
GO111MODULE="on" go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.26.0
GO111MODULE="on" go get github.com/giantswarm/luigi
GO111MODULE="on" go get github.com/giantswarm/architect
GO111MODULE="on" go get github.com/giantswarm/gsctl
GO111MODULE="on" go get github.com/giantswarm/devctl
env GIT_TERMINAL_PROMPT=1 GO111MODULE="on" go get github.com/giantswarm/opsctl

# IntelliJ
if ! ls /opt/idea-* 1> /dev/null 2>&1; then
  printf "Installing IntelliJ\n"
  wget https://download.jetbrains.com/idea/ideaIU-2020.1.tar.gz
  sudo tar -xzf ideaIU*.tar.gz -C /opt
  sudo chown -R "${USER}":"${USER}" /opt/idea-IU*
  rm ideaIU*.tar.gz
fi

# SDKMan
if test ! -f /home/jose/.sdkman/src/sdkman-main.sh; then
  curl -s "https://get.sdkman.io" | bash
fi

# Keybase
if ! dpkg -s keybase; then
  curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
  sudo apt install -y ./keybase_amd64.deb
  rm keybase_amd64.deb
  #run_keybase
fi

# Sublime Text
if ! dpkg -s sublime-text; then
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install sublime-text
fi

# kubens / kubectx
if test ! -f /usr/local/bin/kubectx; then
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
  mkdir -p ~/.oh-my-zsh/completions
  chmod -R 755 ~/.oh-my-zsh/completions
  ln -s /opt/kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
  ln -s /opt/kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
fi

# pre-commit
if test ! -f ~/bin/pre-commit; then
  curl https://pre-commit.com/install-local.py | python3 -
fi

# Oh-my-zsh
if [ ! -d "~/.oh-my-zsh" ]; then
  printf "Installing ohmyzsh\n"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
