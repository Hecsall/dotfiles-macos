# Python prompt segment - shows the version UV would use, only inside a
# folder that looks like a Python project.

_python_prompt_update() {
  PYTHON_PROMPT=''

  local markers=(pyproject.toml requirements.txt setup.py setup.cfg Pipfile .python-version)
  local found=0 marker
  for marker in $markers; do
    [[ -e $marker ]] && found=1 && break
  done
  (( found )) || return

  # UV pins the version per-project in .python-version, prefer reading it
  # directly (no subprocess). Otherwise fall back to the active venv or PATH.
  local python_version
  if [[ -f .python-version ]]; then
    python_version=$(<.python-version)
  elif [[ -n $VIRTUAL_ENV ]]; then
    python_version=$("$VIRTUAL_ENV/bin/python" --version 2>&1 | awk '{print $2}')
  elif (( $+commands[python3] )); then
    python_version=$(python3 --version 2>&1 | awk '{print $2}')
  fi

  [[ -z $python_version ]] && return

  PYTHON_PROMPT=" %F{yellow}${PYTHON_SYMBOL} ${python_version}%f"
}

precmd_functions+=( _python_prompt_update )
