# Loaded once per login shell, after .zshenv.

# macOS's /etc/zprofile (run before this file) invokes path_helper, which
# rebuilds PATH from /etc/paths(.d) and demotes everything .zshenv prepended
# (Homebrew, Volta, cargo, uv) below /usr/bin et al. Re-prepend them here so
# Homebrew's versions (e.g. nano) take precedence over the system ones.
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$VOLTA_HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
fi

# OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Private environment (tokens, machine-specific exports, etc.)
if [[ -s "$PRIVATE_DOTFILES_PATH/zsh/profile.sh" ]]; then
  source "$PRIVATE_DOTFILES_PATH/zsh/profile.sh"
fi
