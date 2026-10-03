# Node.js prompt segment - shows the active Volta-pinned version, only when
# the cwd looks like a Node project.

_node_prompt_update() {
  NODE_PROMPT=''

  [[ -f package.json || -f .node-version || -d node_modules ]] || return

  if (( ! $+commands[volta] )); then
    NODE_PROMPT=" %F{202}${NODE_SYMBOL} volta not found%f"
    return
  fi

  local node_version
  node_version=$(volta list -c --format plain node 2>/dev/null | awk -F'[@ ]' '/node/{print $3}')
  [[ -z $node_version || $node_version == system ]] && return

  NODE_PROMPT=" %F{green}${NODE_SYMBOL} ${node_version}%f"
}

precmd_functions+=( _node_prompt_update )
