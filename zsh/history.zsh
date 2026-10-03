# History file settings
HISTFILE="$HOME/.zsh_history"
HISTSIZE=15000
SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY     # Save timestamps
setopt SHARE_HISTORY        # Share history across open sessions
setopt HIST_IGNORE_ALL_DUPS # Don't keep duplicate commands
setopt HIST_SAVE_NO_DUPS    # Don't write duplicates to the history file
setopt HIST_FIND_NO_DUPS    # Skip duplicates when searching
setopt HIST_IGNORE_SPACE    # Don't save lines starting with a space

# Substring history search on Up/Down (provided by zsh-history-substring-search,
# loaded in plugins.zsh). Matches anywhere in the command, e.g. typing "push"
# and pressing Up will find a previously run "npm run push".
# Guarded: skips silently if the plugin isn't installed (brew bundle not run yet).
if (( $+widgets[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi
