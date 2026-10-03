# Central place to customize prompt icons, symbols and misc shell options.
# Tweak these without touching the logic in the other zsh/*.zsh files.

# Preferred cli editors
export EDITOR='nano'
export VISUAL='nano'

# LS colors (https://geoff.greer.fm/lscolors/)
export LSCOLORS="ExFxcxdxbxegedabagacad"
export LS_COLORS="di=1;34:ln=1;35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Prompt symbol shown on the input line (\UF8FF renders as the Apple logo)
export PROMPT_SYMBOL='シ'

# Per-segment icons
export NODE_SYMBOL='⬢'
export RUST_SYMBOL='⚙'
export PYTHON_SYMBOL='🐍'

# Git status icons (shown after "on <branch>")
export GIT_ICON_CLEAN='✔'
export GIT_ICON_STAGED='●'
export GIT_ICON_UNSTAGED='✚'
export GIT_ICON_UNTRACKED='…'
export GIT_ICON_UNMERGED='✖'
export GIT_ICON_STASHED='⚑'
export GIT_ICON_AHEAD='↑'
export GIT_ICON_BEHIND='↓'

# iTerm2 shell integration, if installed
[[ -f "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"
