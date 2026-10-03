#!/bin/zsh
# Try these dotfiles in an isolated sandbox, without touching your real $HOME
# or running install.sh for real.
#
# Usage:
#   ./sandbox.sh          # drop into an interactive shell using the sandbox
#   ./sandbox.sh --clean  # wipe sandbox state (history, etc.) first

set -e

ABS_DOTFILES_PATH=${0:A:h}
# Strip the trailing slash macOS puts on $TMPDIR - a double slash here would
# make $HOME and $PWD mismatch, breaking the "%~" prompt truncation.
SANDBOX_HOME="${${TMPDIR:-/tmp}%/}/dotfiles-sandbox"

[[ "$1" == "--clean" ]] && rm -rf "$SANDBOX_HOME"

mkdir -p "$SANDBOX_HOME"
ln -sfn "$ABS_DOTFILES_PATH/.zshenv" "$SANDBOX_HOME/.zshenv"
ln -sfn "$ABS_DOTFILES_PATH/.zshrc" "$SANDBOX_HOME/.zshrc"
ln -sfn "$ABS_DOTFILES_PATH/.zprofile" "$SANDBOX_HOME/.zprofile"
ln -sfn "$ABS_DOTFILES_PATH/.nanorc" "$SANDBOX_HOME/.nanorc"
ln -sfn "$ABS_DOTFILES_PATH/nano-highlight" "$SANDBOX_HOME/.nano"

# Seed demo project folders so every prompt segment is easy to try right away
mkdir -p "$SANDBOX_HOME/playground/node-demo" "$SANDBOX_HOME/playground/rust-demo" "$SANDBOX_HOME/playground/python-demo"
[[ -d "$SANDBOX_HOME/playground/git-demo/.git" ]] || git init -q "$SANDBOX_HOME/playground/git-demo"
[[ -f "$SANDBOX_HOME/playground/node-demo/package.json" ]] || echo '{}' > "$SANDBOX_HOME/playground/node-demo/package.json"
[[ -f "$SANDBOX_HOME/playground/rust-demo/Cargo.toml" ]] || echo '[package]' > "$SANDBOX_HOME/playground/rust-demo/Cargo.toml"
[[ -f "$SANDBOX_HOME/playground/python-demo/.python-version" ]] || echo '3.12.4' > "$SANDBOX_HOME/playground/python-demo/.python-version"

echo "==> Sandbox \$HOME: $SANDBOX_HOME"
echo "==> Demo folders in ~/playground: git-demo, node-demo, rust-demo, python-demo"
echo "==> Type 'exit' to leave."

cd "$SANDBOX_HOME"

# env -i clears the inherited environment: VS Code (and some terminals) export
# their own ZDOTDIR for shell-integration, which would otherwise take priority
# over $HOME and silently load your real ~/.zshenv instead of this sandbox.
exec env -i \
  HOME="$SANDBOX_HOME" \
  ZDOTDIR="$SANDBOX_HOME" \
  TERM="$TERM" \
  PATH="$PATH" \
  LANG="${LANG:-en_US.UTF-8}" \
  zsh -i
