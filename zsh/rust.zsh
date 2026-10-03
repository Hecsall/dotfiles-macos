# Rust prompt segment - shows the cargo version, only inside a Rust project.

_rust_prompt_update() {
  RUST_PROMPT=''

  [[ -f Cargo.toml ]] || return

  if (( ! $+commands[cargo] )); then
    RUST_PROMPT=" %F{202}${RUST_SYMBOL} cargo not found%f"
    return
  fi

  local cargo_version
  cargo_version=$(cargo --version 2>/dev/null | awk '{print $2}')
  [[ -z $cargo_version ]] && return

  RUST_PROMPT=" %F{green}${RUST_SYMBOL} ${cargo_version}%f"
}

precmd_functions+=( _rust_prompt_update )
