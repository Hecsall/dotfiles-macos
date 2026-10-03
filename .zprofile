# Loaded once per login shell, after .zshenv.

# OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Private environment (tokens, machine-specific exports, etc.)
if [[ -s "$PRIVATE_DOTFILES_PATH/zsh/profile.sh" ]]; then
  source "$PRIVATE_DOTFILES_PATH/zsh/profile.sh"
fi
