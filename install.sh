#!/bin/zsh
set -e

# Absolute path of this dotfiles checkout (follows symlinks)
ABS_DOTFILES_PATH=${0:A:h}

echo "==> Installing dotfiles from $ABS_DOTFILES_PATH"

# --- Homebrew -------------------------------------------------------------
if ! command -v brew &> /dev/null; then
  echo "Homebrew is required but not installed."
  echo "Install it from https://brew.sh then re-run this script."
  exit 1
fi

echo "==> Installing/updating tools from Brewfile"
brew bundle --file="$ABS_DOTFILES_PATH/Brewfile"

# Install Rust via the official rustup script (not Homebrew)
if [[ ! -x "$HOME/.cargo/bin/rustc" ]]; then
  echo "==> Installing the Rust toolchain via rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable
fi

# --- Submodules -------------------------------------------------------------
echo "==> Fetching submodules"
git -C "$ABS_DOTFILES_PATH" submodule update --init --recursive

# --- Symlinks ---------------------------------------------------------------
# This overwrites existing files in $HOME, back them up first if needed.
echo "==> Symlinking dotfiles into \$HOME"
ln -sfnv "$ABS_DOTFILES_PATH/.zshenv" ~/.zshenv
ln -sfnv "$ABS_DOTFILES_PATH/.zshrc" ~/.zshrc
ln -sfnv "$ABS_DOTFILES_PATH/.zprofile" ~/.zprofile
ln -sfnv "$ABS_DOTFILES_PATH/.nanorc" ~/.nanorc
ln -sfnv "$ABS_DOTFILES_PATH/nano-highlight" ~/.nano

# --- Private dotfiles ---------------------------------------------------------
if [[ -d "$ABS_DOTFILES_PATH/private" ]] && [[ -n "$(ls -A "$ABS_DOTFILES_PATH/private")" ]]; then
  echo "==> Installing private dotfiles"
  "$ABS_DOTFILES_PATH/private/install.sh"
fi

echo "==> Done. Restart your terminal (or run 'exec zsh') to apply changes."
