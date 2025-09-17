
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
    sqlite3 "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/History" "select distinct id as id, title as title, url as url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') as lastVisitTime, visit_count as visitCount from urls" | fzf
}

func bm() {
    # jq 'def r(f): .name as $n | map(if .type == "folder" then .children | r($n + "-" + .) else .url + (.name | f) end); .roots.other.children | r(.)' "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
    jq 'def r: map(if .type == "folder" then .children | r | .[] else .name + "-" + .url end); .roots.other.children | r' "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/Bookmarks"
}

# snippets
snp() {
  cat $HOME/.snippets/snippetslab.json | jq -r --raw-output0 '.contents.snippets | map({title:.title, content: .fragments[0].content}) | .[] | "\(.title)#\(.content)"' | fzf --read0 -d '#' --with-nth='{1}' --preview='echo {2} | bat' --accept-nth='{2}'
}

# git diff fzf
gdiff () {
  git diff --name-only --merge-base master | fzf --preview='git diff --merge-base master {}'
}

# run environment hooks
source $HOME/.env_hooks
