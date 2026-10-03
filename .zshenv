# Loaded for every zsh invocation (scripts, subshells, interactive).
# Keep this file minimal: just paths and variables needed everywhere.

# Resolve the real dotfiles directory by following the ~/.zshenv symlink,
# so this works no matter where the repo is checked out.
export DOTFILES_PATH=${$(realpath ~/.zshenv):h}
export PRIVATE_DOTFILES_PATH="$DOTFILES_PATH/private"

# Homebrew
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# Volta (Node.js version manager)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Rust / Cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# uv / user-local binaries
export PATH="$HOME/.local/bin:$PATH"
