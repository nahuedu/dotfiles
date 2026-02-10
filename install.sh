cp -iv .zshrc $HOME

mkdir -p $HOME/.config/ghostty 
cp -ivr ghostty/config $HOME/.config/ghostty 

mkdir -p $HOME/.config/omp
cp -ivr omp/nano.omp.json $HOME/.config/omp

mkdir -p $HOME/.config/vim
cp -ivr vim/vimrc $HOME/.config/vim

mkdir -p $HOME/.config/tmux
cp -ivr tmux/tmux.conf $HOME/.config/tmux

mkdir -p $HOME/.hammerspoon
cp -ivr hammerspoon/init.lua $HOME/.hammerspoon

mkdir -p $HOME/.config/intellij
cp -ivr intellij/intellij $HOME/.config/intellij
chmod +x $HOME/.config/intellij/intellij

HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_UPGRADE=true brew install bat fzf fd jq yq jo jandedobbeleer/oh-my-posh/oh-my-posh tmux git

HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_UPGRADE=true brew install --cask font-jetbrains-mono maccy karabiner-elements hammerspoon finetune
