# Interactive shell configuration.

# Completion system
zstyle ':completion:*' completer _expand _complete _ignored
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' verbose true
autoload -Uz compinit && compinit
autoload -Uz add-zsh-hook

unsetopt beep

# Emacs-style keybindings
bindkey -e

# --- Dotfiles modules ---------------------------------------------------
source "$DOTFILES_PATH/zsh/variables.zsh"
source "$DOTFILES_PATH/zsh/plugins.zsh"
source "$DOTFILES_PATH/zsh/history.zsh"
source "$DOTFILES_PATH/zsh/aliases.zsh"
source "$DOTFILES_PATH/zsh/git-prompt.zsh"
source "$DOTFILES_PATH/zsh/node.zsh"
source "$DOTFILES_PATH/zsh/rust.zsh"
source "$DOTFILES_PATH/zsh/python.zsh"
source "$DOTFILES_PATH/zsh/time.zsh"
source "$DOTFILES_PATH/zsh/prompt.zsh"

# Private aliases/functions
if [[ -s "$PRIVATE_DOTFILES_PATH/zsh/aliases.sh" ]]; then
  source "$PRIVATE_DOTFILES_PATH/zsh/aliases.sh"
fi
