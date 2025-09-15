cp -iv .zshrc $HOME

mkdir -p $HOME/.config/ghostty 
cp -ivr ghostty/config $HOME/.config/ghostty 

mkdir -p $HOME/.config/omp
cp -ivr omp/nano.omp.json $HOME/.config/omp

HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_UPGRADE=true brew install bat fzf fd jq yq jo jandedobbeleer/oh-my-posh/oh-my-posh tmux git

HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_UPGRADE=true brew install --cask font-jetbrains-mono
