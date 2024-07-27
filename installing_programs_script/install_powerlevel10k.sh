#!/bin/bash

yay -Sy --noconfirm ttf-meslo-nerd-font-powerlevel10k zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc
