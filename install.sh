#!/bin/bash

ln -sf $HOME/dotfiles/.gitconfig $HOME/.gitconfig

mv $HOME/.bashrc $HOME/.oldbashrc &> /dev/null
ln -sf $HOME/dotfiles/.bashrc $HOME/.bashrc

mv $HOME/.zshrc $HOME/.oldzshrc &> /dev/null
ln -sf $HOME/dotfiles/.zshrc $HOME/.zshrc

mv $HOME/.p10k.zsh $HOME/.oldp10k.zsh &> /dev/null
ln -sf $HOME/dotfiles/.p10k.zsh $HOME/.p10k.zsh


ln -sf $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf

