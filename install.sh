#!/bin/bash

THISDIR=$HOME/.dotz
HOMEDIR=$HOME
LOCALDIR=$HOME/.local/

echo "This sets things up!"
echo "It'll set up oh my zsh, my zsh and bash rc, vim, and vifm."
echo "It'll install vifm locally, and it'll be able to build ncurses locally as well if it doesn't find it."

# Check that .dotz is in home
if [[ ! -d $THISDIR ]]
then
    echo "Please place .dotz in $HOME"
    exit 1
fi

# Ensure submodules are cloned
git submodule update --init --recursive

# Install ncurses?
## 
if \
       [[ -f "/usr/include/ncurses.h" ]] || \
       [[ -d "$NCDIR" ]] || \
       [[ -f "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/curses.h" ]]; then
    echo "libncurses appears to be installed; skipping..."
    else
    echo "libncurses not found!"
    read -p "Install ncurses (vifm requires ncurses)? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing ncurses"
        mkdir -p $LOCALDIR
        mkdir -p $NCDIR
        rm -rf local
        mkdir local
        cd local && \
            wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.4.tar.gz && \
            tar -xzf ncurses*.tar.gz && \
            rm ncurses*.tar.gz && \
            cd ncurses-6.4 && \
            ./configure \
                --enable-widec --with-shared \
                --prefix=$NCDIR \
                CFLAGS="-I$NCDIR/include" \
                LIBS="-L$NCDIR/lib" && \
            make && make install
        cd $THISDIR
    fi
fi

# Install vifm?
## 
if \
       [[ -f "$LOCALDIR/bin/vifm" ]]; then
    echo "vifm appears to be installed; skipping..."
else
    echo "which vifm: $(which vifm)"
    read -p "Install vifm (if you don't see a path above you probably need to)? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing vifm"
        mkdir -p $LOCALDIR/bin
        if [[ -d "$NCDIR" ]]; then
        NCARG="--with-curses=$NCDIR --with-curses-name=ncursesw"
        fi
        cd $THISDIR/third_party/vifm/ && ./configure --prefix=$LOCALDIR $NCARG && make && make install
        cd $THISDIR
    fi
fi

# Do the linking
# Common rc (my solution to having common args between zshrc and bashrc)
echo "Linking commonrc to ~/.commonrc"
rm $HOMEDIR/.commonrc
ln -s $THISDIR/commonrc $HOMEDIR/.commonrc

# ZSH rc and logout
echo "Linking zhsrc to ~/.zshrc"
rm $HOMEDIR/.zshrc
ln -s $THISDIR/zshrc $HOMEDIR/.zshrc
echo "Linking zlogout to ~/.zlogout"
rm $HOMEDIR/.zlogout
ln -s $THISDIR/zlogout $HOMEDIR/.zlogout

# Bashrc
echo "Appending bashrc to ~/.bashrc"
rm $HOMEDIR/.bashrc2
ln -s $THISDIR/bashrc $HOMEDIR/.bashrc2
echo "[ -f $HOME/.bashrc2 ] && source $HOME/.bashrc2" >> $HOMEDIR/.bashrc

# Inputrc
if [[ "$OSTYPE" == "darwin"* ]]; then
    INPRC=$THISDIR/inputrc.mac
else
    INPRC=$THISDIR/inputrc
fi
echo "Linking inputrc to $HOMEDIR/.inputrc"
rm $HOMEDIR/.inputrc
ln -s $THISDIR/inputrc $HOMEDIR/.inputrc

# Tmux conf
if [[ -f "/usr/bin/tmux" ]]; then
    echo "Linking tmux.conf to $HOMEDIR/.tmux.conf"
    rm $HOMEDIR/.tmux.conf
    ln -s $THISDIR/tmux.conf $HOMEDIR/.tmux.conf
fi

# Replace the vifm files
echo "Linking vifm files..."
rm -r $HOMEDIR/.vifm
ln -s $THISDIR/vifm $HOMEDIR/.vifm

# Replace the vim files
echo "Linking vim files..."
rm -r $HOMEDIR/.vim
rm -r $HOMEDIR/.vimrc
ln -s $THISDIR/vim $HOMEDIR/.vim
ln -s $THISDIR/vimrc $HOMEDIR/.vimrc

# Setup oh my zsh
rm -rf $HOMEDIR/.oh-my-zsh
echo "Linking oh-my-zsh to home directory"
ln -s $THISDIR/third_party/zsh/ohmyzsh $HOMEDIR/.oh-my-zsh
ln -s $THISDIR/third_party/zsh/zsh-autosuggestions $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions


echo "Installation complete"
