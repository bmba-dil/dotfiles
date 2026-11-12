# Better ls
alias ls='eza -a --icons'

# Detailed listing
alias ll='eza -lh --icons --git'

# Detailed listing including hidden files
alias la='eza -lah --icons --git'

# Tree view
alias tree='eza --tree --icons'

# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls

# Better cat
alias cat='bat'

# =========================================================
# Core utilities
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'

# =========================================================
# Navigation
# =========================================================

alias -- -='cd -' # -- prevents - being parsed as a flag; cd - jumps to previous directory

# =========================================================
# Editor
# =========================================================

alias vim='nvim'

# =========================================================
# Git
# =========================================================

alias glog='PAGER="less -F -X" git log' # -F quit if one screen, -X no clear on exit
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# =========================================================
# Personal
# =========================================================

alias src="source ~/.config/zsh/.zshrc"
alias ta="tmux a"
alias ccdp="claude --dangerously-skip-permissions"
alias oc="opencode"
alias python="python3"
alias proj="cd ~/projects"
alias srcvenv="source .venv/bin/activate"
alias cl="clear"

# =========================================================
# get-ship-done
# =========================================================

alias gsd1="node $HOME/Projects/gsdup/get-shit-done/bin/gsd-tools.cjs"
alias gsd1-dashboard="node $HOME/Projects/gsdup/dashboard-serve.cjs"
export GSD_PATH="$HOME/.config/opencode"
export GSD_TOOLS="$GSD_PATH/bin/gsd-tools.cjs"

# =========================================================
# ta: tmux attach-or-create for this directory
# =========================================================

tat() {
  local name
  name=${$(basename "$PWD")//./}

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach -t "$name"
  elif [[ -f .envrc ]] && command -v direnv >/dev/null; then
    direnv exec . tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

# =========================================================
# appid <anything>    Handy to find app-ids for any app easily
# =========================================================
appid() {
  osascript -e "id of app \"$1\""
}
