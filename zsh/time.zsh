# Command execution time, shown on the right side of the prompt (see prompt.zsh)

function preexec() {
  cmd_start=$(($(print -P %D{%s%6.}) / 1000))
}

function precmd() {
  if [[ -n $cmd_start ]]; then
    local now=$(($(print -P %D{%s%6.}) / 1000))
    local d_ms=$((now - cmd_start))
    local d_s=$((d_ms / 1000))
    local ms=$((d_ms % 1000))
    local s=$((d_s % 60))
    local m=$(((d_s / 60) % 60))
    local h=$((d_s / 3600))

    if   ((h > 0)); then cmd_time="${h}h${m}m"
    elif ((m > 0)); then cmd_time="${m}m${s}s"
    elif ((s > 9)); then cmd_time="${s}.$(printf %03d $ms | cut -c1-2)s"
    elif ((s > 0)); then cmd_time="${s}.$(printf %03d $ms)s"
    else cmd_time="${ms}ms"
    fi

    unset cmd_start
  else
    unset cmd_time
  fi
}
