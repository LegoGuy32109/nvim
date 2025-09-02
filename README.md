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

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# rust
rustup default stable
```

# .bashrc 
```
# Add local bin to PATH if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
eval "$(zoxide init bash)"
```
