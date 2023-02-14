#!/bin/bash

THISDIR=$HOME/.dotz
HOMEDIR=$HOME
LOCALDIR=$HOME/.local/
NCDIR=$HOME/.ncurses/

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

# Install bat?
## 
if \
    [[ -f "$LOCALDIR/bin/bat" ]]; then
#    Not explicitly checking if bat is recognized because we want our minimum version satisfied
#    [[ -f "$(which bat)" ]]; then
    echo "bat appears to be installed ($(which bat)); skipping..."
else
    echo "which bat: $(which bat)"
    read -p "Install bat? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing bat"
        mkdir -p $LOCALDIR/bin
        TMPDIR=$THISDIR/tmp
        mkdir -p $TMPDIR
        BATURL=""
        arch="$(uname -m)"
        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-x86_64-apple-darwin.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-i686-unknown-linux-gnu.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-x86_64-unknown-linux-gnu.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-arm-unknown-linux-gnueabihf.tar.gz"
        fi
        if [[ "$BATURL" != "" ]]; then
            echo "Fetching static bat binaries"
            cd $TMPDIR && wget $BATURL && tar -xzf bat*.tar.gz && rm bat*.tar.gz && mv bat*/bat $LOCALDIR/bin/bat
        else
            echo "Failed to install static bat. Please install it manually before proceeding."
            echo "arch: $arch"
            echo "ostype: $OSTYPE"
            exit 1
        fi
        rm -rf $TMPDIR
    fi
fi

# Install rg?
## 
if \
    [[ -f "$LOCALDIR/bin/rg" ]]; then
#    Not explicitly checking if rg is recognized because we want our minimum version satisfied
#    [[ -f "$(which rg)" ]]; then
    echo "Ripgrep (rg) appears to be installed ($(which rg)); skipping..."
else
    echo "which rg: $(which rg)"
    read -p "Install ripgrep? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing ripgrep"
        mkdir -p $LOCALDIR/bin
        TMPDIR=$THISDIR/tmp
        mkdir -p $TMPDIR
        RGURL=""
        arch="$(uname -m)"
        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            RGURL="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-apple-darwin.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            RGURL="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            RGURL="https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-arm-unknown-linux-gnueabihf.tar.gz"
        fi
        if [[ "$RGURL" != "" ]]; then
            echo "Fetching static ripgrep"
            cd $TMPDIR && wget $RGURL && tar -xzf ripgrep*.tar.gz && rm ripgrep*.tar.gz && mv ripgrep*/rg $LOCALDIR/bin/rg
        else
            echo "Failed to install static ripgrep. Please install it manually before proceeding."
            echo "arch: $arch"
            echo "ostype: $OSTYPE"
            exit 1
        fi
        rm -rf $TMPDIR
    fi
fi

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
    [[ -f "$LOCALDIR/bin/vifm" ]]; then \
#    Not explicitly checking if vifm is recognized because we want our minimum version satisfied
#    [[ -f "$(which vifm)" ]]; then
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

# Install fzf?
## 
if \
    [[ -d "$HOMEDIR/.fzf" ]]; then
#    Not explicitly checking if fzf is recognized because we want our minimum version satisfied
#    [[ -f "$(which fzf)" ]]; then
    echo "Fuzzy finder (fzf) appears to be installed ($(which fzf)); skipping..."
else
    echo "which fzf: $(which fzf)"
    read -p "Install fzf? [y/n]: " -n 1 -r
    echo "WARNING: DO NOT ADD IT TO BASHRC; I WILL ADD IT FOR YOU!!!"
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing fzf"
        cd $THISDIR/third_party/fzf/ && ./install
        cd $THISDIR
        rm -rf $HOMEDIR/.fzf
        ln -s $THISDIR/third_party/fzf $HOMEDIR/.fzf
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
if [[ "$OSTYPE" == "darwin"* ]]; then
    VIFMRC=$THISDIR/vifmrc.mac
else
    VIFMRC=$THISDIR/vifmrc
fi
rm -rf $HOMEDIR/.vifm
cp -r $THISDIR/vifm $HOMEDIR/.vifm
ln -s $VIFMRC $HOMEDIR/.vifm/vifmrc

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
rm -f $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s $THISDIR/third_party/zsh/zsh-autosuggestions $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Set up my custom scripts
echo "Linking custom scripts"
rm -f $LOCALDIR/bin/cnda
rm -f $LOCALDIR/bin/kssh
rm -f $LOCALDIR/bin/sagent
ln -s $THISDIR/scripts/cnda $LOCALDIR/bin/cnda 
ln -s $THISDIR/scripts/kssh $LOCALDIR/bin/kssh
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -s $THISDIR/scripts/sagent.mac $LOCALDIR/bin/sagent
else
    ln -s $THISDIR/scripts/sagent $LOCALDIR/bin/sagent
fi


echo "Installation complete"
