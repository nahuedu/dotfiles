
PLUGINS_HOME=$HOME/.zsh_plugins
[ ! -d $PLUGINS_HOME ] && mkdir -p $PLUGINS_HOME

# completions
[ ! -d $PLUGINS_HOME/zsh-completions ] && git clone https://github.com/zsh-users/zsh-completions.git $PLUGINS_HOME/zsh-completions
fpath=($PLUGINS_HOME/zsh-completions/src $fpath)

autoload -U compinit
compinit

# fzf tab completions
[ ! -d $PLUGINS_HOME/fzf-tab ] && git clone https://github.com/Aloxaf/fzf-tab $PLUGINS_HOME/fzf-tab
source $PLUGINS_HOME/fzf-tab/fzf-tab.plugin.zsh

# auto suggestions
[ ! -d $PLUGINS_HOME/zsh-autosuggestions ] && git clone https://github.com/zsh-users/zsh-autosuggestions.git $PLUGINS_HOME/zsh-autosuggestions
source $PLUGINS_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlight
[ ! -d $PLUGINS_HOME/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $PLUGINS_HOME/zsh-syntax-highlighting
source $PLUGINS_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# colors in autocomplete results
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# disable default zsh completions menu
zstyle ':completion:*' menu no

# directory preview for fzf-tab completion menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# basic aliases
alias ls='ls --color'

# load oh-my-posh if not apple terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
   eval "$(oh-my-posh init zsh --config $HOME/.config/omp/nano.omp.json)"
fi

# color for autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# fzf default ops
export FZF_DEFAULT_OPTS="--style full"

# bat theme
export BAT_THEME=ansi

# quick links alias
alias q="cat $XDG_CONFIG_HOME/.quicklinks | jq -r '.[] | \"\(.name) - \(.link)\"' | fzf -d '-' --bind 'enter:become(open {2})'"


export N_CHROME_PROFILE_DIR=Default
func hist() {
sqlite3 "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/History" "select distinct id as id, title as title, url as url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') as lastVisitTime, visit_count as visitCount from urls" | fzf -d '|' --with-nth='{2}' --preview='echo {3}' --bind 'enter:execute(open {3})' --wrap --wrap-sign='' --gap --gap-line
}

func bm() {
    # jq 'def r(f): .name as $n | map(if .type == "folder" then .children | r($n + "-" + .) else .url + (.name | f) end); .roots.other.children | r(.)' "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
    jq 'def r: map(if .type == "folder" then .children | r | .[] else .name + "-" + .url end); .roots.other.children | r' "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/Bookmarks"
}

# snippets
snp() {
  for s in $HOME/.snippets/*; do
    lines=($(cat $s))
  done
  echo $lines[1]
}

move_window() {
  text=$1
  ws=$2
  window_id=$(aerospace list-windows --all --json | jq --arg t $text 'map(select(.["app-name"] | test($t))) | .[] | .["window-id"]')
  if [[ -z $window_id ]]; then
    echo "no window found"
  else
    aerospace move-node-to-workspace --window-id $window_id $ws
  fi
}

startup() {
  open /Applications/WhatsApp.localized/WhatsApp.app
  sleep 0.2
}

# quick links
l() {
  url=$(cat $HOME/.links | fzf)
  open $url
}

# git diff fzf (current branch)
gd () {

  if [[ -v 1 ]]; then
    branch=$1
  elif [[ -a .git/refs/heads/master ]]; then
    branch=master
  else
    branch=main
  fi

  files=$(git diff --name-only --merge-base $branch HEAD)

  echo $files | fzf --wrap --preview-window=wrap --preview="git diff --color=always --merge-base $branch HEAD -- {}"
}

# git diff fzf (local changes)
gs () {
  staged=$(git diff --staged --name-only)
  nstaged=$(git diff --name-only)
  list=(${^staged}"|staged" ${^nstaged}"|nstaged")

  echo ${(F)list} | fzf --preview-window=wrap -d "|" --wrap --with-nth='{1} ({2})' --preview="if [[ {2} == staged ]] then git diff --color=always --staged {1}; else git diff --color=always {1}; fi"
}

# run environment hooks
source $HOME/.env_hooks
