#!/bin/bash

set -ex

# Omakub on fresh Ubuntu 24.04
wget -qO- https://omakub.org/install | bash

# Ollama for local LLM dev
curl -fsSL https://ollama.com/install.sh | sh

# Rustup for Rust programs
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Bun for JS/TS projects
curl -fsSL https://bun.sh/install | bash

# uv for Python projects
curl -LsSf https://astral.sh/uv/install.sh | sh

# Tailscale for local VPN
curl -fsSL https://tailscale.com/install.sh | sh

# Zola for static sites
wget https://github.com/getzola/zola/releases/download/v0.18.0/zola-v0.18.0-x86_64-unknown-linux-gnu.tar.gz -O zola.tar.gz
tar xzvf zola.tar.gz
chmod +x zola
mv zola ~/bin/zola
rm zola.tar.gz

# System packages
sudo apt install nala
sudo nala install python3-venv ffmpeg

# Docker tools - (if not using Omakub)
sudo nala install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo nala update -y
sudo nala install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker compose plugin
curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o docker-compose
chmod +x docker-compose
sudo mv docker-compose /bin/docker-compose

# User tools i like to have on-hand
python3 -m venv ~/.venv/
~/.venv/bin/pip install ansible yt-dlp boto3 awscli

# SSH keys and config for git
mkdir ~/.ssh
ssh-keygen -f ~/.ssh/github.pem
cat << EOF > ~/.ssh/config
Host github
  IdentityFile ~/.ssh/github.pem
  User git
  HostName github.com
EOF

# Some repos i have in the structure i like
mkdir -p ~/git/github.com/lfglance
cd ~/git/github.com/lfglance/
git clone github:lfglance/pastebin-backend
git clone github:lfglance/prowler-ui
git clone github:lfglance/lfglance.github.io
cd ~/

# Basic Bashrc
cat << EOF > ~/.bashrc
source ~/.local/share/omakub/defaults/bash/rc

# PS1
BLUE='\[\e[34m\]'
GREEN='\[\e[32m\]'
NOCOLOR='\[\e[0m\]'
#GIT_BRANCH="$(git branch --show-current 2>/dev/null)"
PROMPT_COMMAND='PS1_CMD1=$(echo "(`git branch --show-current 2>/dev/null`) ")'
#if [[ "${GIT_BRANCH}" ]]; then echo "(${GIT_BRANCH})"; fi
PS1="${BLUE}\${PS1_CMD1}${GREEN}\$(pwd | sed s_/home/lance_~_) \\$ ${NOCOLOR}"

# Editor used by CLI
export EDITOR=nvim
export SUDO_EDITOR=$EDITOR

# rust tools
source $HOME/.cargo/env

# bun
export PATH=$HOME/.bun/bin:$PATH
[ -s "/home/lance/.bun/_bun" ] && source "/home/lance/.bun/_bun"

# local bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/go/bin

# python stuff
export PATH=$PATH:$HOME/.venv/bin

# aliases
alias vim="nvim"
alias rc="nvim ~/.bashrc && source ~/.bashrc"
alias sshconf="nvim ~/.ssh/config"
alias gst="git status"
alias gc="git commit"
alias gp="git push"
alias gup="git pull"
alias gacp="git add -A; git commit; git push origin"
alias gd="git diff"
alias l="ls -l -snew"
alias dc="docker-compose"
alias x="exit"
alias c="clear"
alias tf="terraform"

cdd() {
  mkdir ${1}
  cd ${1}
}
EOF


