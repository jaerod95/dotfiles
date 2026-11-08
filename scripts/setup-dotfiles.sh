ln -sf $PWD/kitty.conf ~/.config/kitty/kitty.conf
mkdir -p ~/.config/ghostty && ln -sf $PWD/ghostty/config ~/.config/ghostty/config
ln -sf $PWD/tmux.conf ~/.tmux.conf

ln -sf $PWD/aerospace.toml ~/.aerospace.toml
ln -sf $PWD/git/gitconfig ~/.gitconfig
ln -sf $PWD/nvim ~/.config/nvim
ln -sf $PWD/zsh/zshrc ~/.zshrc

touch $HOME/.work.sh

# Tailscale: run tailscaled as a system LaunchDaemon (starts at boot, needs root)
if command -v tailscaled >/dev/null 2>&1; then
  sudo brew services start tailscale
  echo "tailscaled started — run 'sudo tailscale up' to log in"
else
  echo "tailscale not installed; run 'brew bundle' first"
fi
