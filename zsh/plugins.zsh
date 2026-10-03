# Native plugin loading.
# Plugins are installed as plain Homebrew formulae (see ../Brewfile) and
# sourced directly from their Homebrew share path. Updating is just
# `brew upgrade`, nothing to pull or manage inside this repo.

local brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"

# Inline suggestions from history as you type (accept with →)
local autosuggestions="$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$autosuggestions" ]] && source "$autosuggestions"

# Up/Down arrow substring search across history (see history.zsh for keybinds)
local hss="$brew_prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$hss" ]] && source "$hss"

# Syntax highlighting MUST be sourced last, after every other widget is defined
local syntax_highlighting="$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$syntax_highlighting" ]] && source "$syntax_highlighting"

unset brew_prefix autosuggestions hss syntax_highlighting
