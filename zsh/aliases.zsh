# Keep this file to short, general-purpose aliases.
# Longer logic belongs in dedicated files inside `bin/`.

# Dotfiles update function - pulls dotfiles repo (and its submodules) and reloads the shell
function update-dotfiles() {
  git -C "$DOTFILES_PATH" pull --recurse-submodules || return 1
  exec zsh
}

alias .u="update-dotfiles"

# ls
alias ls='ls --color=auto'
alias l='ls -1ah'
alias la='ls -lah'

# git
alias gl="git pull"
alias glog="git log --graph --topo-order --pretty='%Cred%h%Creset -%Cblue%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gitgud="git add . && git commit -m '(ノಠ益ಠ)ノ彡┻━┻' && git push"

# Local IP
alias localip="ipconfig getifaddr en0"

# Public IP (uses dnsutils)
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Display directory tree up to 2 levels deep
alias tree2="tree -a -L 2 -I \"node_modules|.git|scripts|.DS_Store|.idea\" ."