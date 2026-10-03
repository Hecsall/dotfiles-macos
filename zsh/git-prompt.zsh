# Native git status segment - no external plugin/submodule (replaces the old
# olivierverdier/zsh-git-prompt dependency). Only 2 git subprocess calls total,
# so it stays fast even without async loading.
#
# Shows: " on <branch> <icons>" only when cwd is inside a git work tree.
# Icons (see variables.zsh to customize): unmerged, staged, unstaged,
# untracked, stashed, ahead, behind - or a single "clean" icon when none apply.

_git_prompt_update() {
  GIT_PROMPT=''

  local status_output
  status_output=$(git status --porcelain=v2 --branch 2>/dev/null) || return

  local branch='' ahead=0 behind=0
  local staged=0 unstaged=0 untracked=0 unmerged=0
  local line

  while IFS= read -r line; do
    case $line in
      '# branch.head '*)
        branch=${line#\# branch.head }
        ;;
      '# branch.ab '*)
        local ab=${line#\# branch.ab }
        ahead=${${ab%% *}#+}
        behind=${ab##* -}
        ;;
      '1 '*|'2 '*)
        local xy=${line[3,4]}
        [[ ${xy[1]} != '.' ]] && (( staged++ ))
        [[ ${xy[2]} != '.' ]] && (( unstaged++ ))
        ;;
      'u '*) (( unmerged++ )) ;;
      '? '*) (( untracked++ )) ;;
    esac
  done <<< "$status_output"

  [[ $branch == '(detached)' ]] && branch='detached'

  local stashed=0
  git rev-parse --verify --quiet refs/stash > /dev/null && stashed=1

  local icons=''
  (( unmerged  )) && icons+="%F{red}${GIT_ICON_UNMERGED}%f"
  (( staged    )) && icons+="%F{green}${GIT_ICON_STAGED}%f"
  (( unstaged  )) && icons+="%F{red}${GIT_ICON_UNSTAGED}%f"
  (( untracked )) && icons+="%F{white}${GIT_ICON_UNTRACKED}%f"
  (( stashed   )) && icons+="%F{blue}${GIT_ICON_STASHED}%f"
  (( ahead     )) && icons+="%F{cyan}${GIT_ICON_AHEAD}%f"
  (( behind    )) && icons+="%F{cyan}${GIT_ICON_BEHIND}%f"
  [[ -z $icons ]] && icons="%F{green}${GIT_ICON_CLEAN}%f"

  GIT_PROMPT=" on %F{magenta}${branch}%f ${icons}"
}

precmd_functions+=( _git_prompt_update )
