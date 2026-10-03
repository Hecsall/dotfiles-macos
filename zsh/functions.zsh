# General-purpose shell functions.

# Pull this dotfiles repo (and its submodules) and reload the shell
function update-dotfiles() {
  local current_path="$(pwd)"
  cd "$DOTFILES_PATH"
  git pull --recurse-submodules
  cd "$current_path"
  exec zsh
}

# Unlock and cache an SSH key passphrase for this terminal session
function keychain-add() {
  if ! command -v keychain &> /dev/null; then
    echo "'keychain' package is not installed."
    return 1
  fi
  eval "$(keychain --agents ssh --eval -q -Q id_rsa id_ed25519)"
}

alias localip="ipconfig getifaddr en0"

# Public IP (uses dnsutils)
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

alias tree2="tree -a -L 2 -I \"node_modules|.git|scripts|.DS_Store|.idea\" ."

# Find the biggest blobs ever committed in a git repo
function git-large-files() {
  git rev-list --objects --all \
    | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
    | sed -n 's/^blob //p' \
    | sort --numeric-sort --key=2 \
    | cut -c 1-12,41- \
    | $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

# Benchmark shell startup time
function timezsh() {
  local shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

# Print a 256-color grid, useful when picking prompt colors
function print-colors() {
  "$DOTFILES_PATH/zsh/print256colors.zsh"
}
