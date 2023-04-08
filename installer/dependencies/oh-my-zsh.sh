#!/bin/bash
# Oh my ZSH

install_oh_my_zsh() {
    rm -rf $HOMEDIR/.oh-my-zsh
    ln -s $THISDIR/third_party/zsh/ohmyzsh $HOMEDIR/.oh-my-zsh
}

configure_oh_my_zsh() {
    # Plugins
    rm -f $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    ln -s $THISDIR/third_party/zsh/zsh-autosuggestions $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    rm -f $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    ln -s $THISDIR/third_party/zsh/zsh-syntax-highlighting $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 

    # Overlay Agnoster theme and Syntax highlighting with monokai colors
    rm -rf $HOMEDIR/.config/zsh
    ln -s $THISDIR/config/zsh $HOMEDIR/.config/zsh
}
