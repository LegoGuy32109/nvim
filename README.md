I don't remember everything but here's what I know

```
wsl -l -v
wsl --set-default Ubuntu
```

```
sudo apt update
sudo apt install -y ripgrep build-essential unzip git fd-find rustup

# add fd to path
sudo ln -sf $(command -v fdfind) /usr/local/bin/fd

# deno
curl -fsSL https://deno.land/x/install/install.sh | sh
# zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
# fuzzy finder for zoxide
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# rust
rustup default stable

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 24

# puppeteer setup
sudo apt-get update
sudo apt-get install -y \
  libnss3 libnspr4 \
  libatk-bridge2.0-0 libatk1.0-0 \
  libgtk-3-0 libx11-xcb1 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 \
  libxcb1 libxkbcommon0 libxshmfence1 \
  libdrm2 libgbm1 \
  libasound2 \
  libglib2.0-0 libpango-1.0-0 libpangocairo-1.0-0 \
  fonts-liberation ca-certificates xdg-utils wget
npx puppeteer install chrome

# stuff for lsps
npm -g i @biomejs/biome
npm -g i @vtsls/language-server
```

# .bashrc 
```
# Add local bin to PATH if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
eval "$(zoxide init bash)"

export GEOH_SHARED_ENVIRONMENT_DIRECTORY="/mnt/c/Users/Josh/GOGEOH/Engineering - Documents/Environments"
```
