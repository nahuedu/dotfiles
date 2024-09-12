
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

