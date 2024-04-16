#!/bin/bash

ln -sf $HOME/dotfiles/.gitconfig $HOME/.gitconfig

mv $HOME/.bashrc $HOME/.oldbashrc &> /dev/null
ln -sf $HOME/dotfiles/.bashrc $HOME/.bashrc

mv $HOME/.vimrc $HOME/.oldvimrc &> /dev/null
ln -sf $HOME/dotfiles/.vimrc $HOME/.vimrc

mv $HOME/.vim $HOME/.oldvim &> /dev/null
ln -sf $HOME/dotfiles/.vim $HOME/.vim

ln -sf $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf

