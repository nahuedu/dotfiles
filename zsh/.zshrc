
# load oh-my-posh if not apple terminal
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
   eval "$(oh-my-posh init zsh --config ~/.nano.omp.json)"
fi

# color for autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=243"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# git bindings for fzf
source ~/Developer/fzf-git.sh/fzf-git.sh

# zsh autosuggestions
source ~/Developer/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh syntax highlight (must be at the end)
source ~/Developer/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# bat theme
export BAT_THEME=ansi

# quick links alias
alias q="cat $HOME/.quicklinks | jq -r '.[] | \"\(.name) - \(.link)\"' | fzf -d '-' --bind 'enter:become(open {2})'"


export N_CHROME_PROFILE_DIR=Default
func hist() {
    sqlite3 "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/History" "select distinct id as id, title as title, url as url, datetime(last_visit_time / 1000000 + (strftime('%s', '1601-01-01')), 'unixepoch', 'localtime') as lastVisitTime, visit_count as visitCount from urls" | fzf
}

func bm() {
    # jq 'def r(f): .name as $n | map(if .type == "folder" then .children | r($n + "-" + .) else .url + (.name | f) end); .roots.other.children | r(.)' "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
    jq 'def r: map(if .type == "folder" then .children | r | .[] else .name + "-" + .url end); .roots.other.children | r' "$HOME/Library/Application Support/Google/Chrome/$N_CHROME_PROFILE_DIR/Bookmarks"
}
