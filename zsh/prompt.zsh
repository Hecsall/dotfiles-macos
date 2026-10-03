# Assembles the final two-line prompt from the segments computed in
# git-prompt.zsh / node.zsh / rust.zsh / python.zsh / time.zsh.
#
# Line 1: <cwd> on <git branch> <git status icon> <node> <cargo> <python>
# Line 2: シ   (prepended to the line where you type)

setopt prompt_subst

PROMPT='%B%F{cyan}%~%f${GIT_PROMPT}${NODE_PROMPT}${RUST_PROMPT}${PYTHON_PROMPT}%b
%B%(?.%F{219}.%F{red})${PROMPT_SYMBOL}%f%b '

RPROMPT='%B%F{223}${cmd_time}%f%b'
