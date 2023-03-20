#!/bin/bash

THISDIR=$HOME/.dotfiles
HOMEDIR=$HOME
LOCALDIR=$HOME/.local/
NCDIR=$HOME/.ncurses/

CMAKEVER="3.25.3"

echo "This sets things up!"
echo "It'll set up oh my zsh, my zsh and bash rc, vim, and vifm."
echo "It'll install vifm locally, and it'll be able to build ncurses locally as well if it doesn't find it."

# Check that .dotfiles is in home
if [[ ! -d $THISDIR ]]
then
    echo "Please place .dotfiles in $HOME"
    exit 1
fi

# Ensure submodules are cloned
git submodule update --init --recursive

# Install cmake?
# I am tired of the old cmakes and having to use conda whenever I need cutlass.
# I am done!
## 
if \
    [[ -f "$LOCALDIR/bin/cmake" ]]; then
#    Not explicitly checking if bat is recognized because we want our minimum version satisfied
#    [[ -f "$(which bat)" ]]; then
    echo "cmake appears to be installed locally; skipping..."
else
    echo "Local cmake was not found. Highly recommended."
    echo "Your current cmake: $(cmake --version)"
    echo "What I'm about to install: $CMAKEVER"
    read -p "Install cmake? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing cmake"
        mkdir -p $LOCALDIR/bin
        mkdir -p $LOCALDIR/share
        TMPDIR=$THISDIR/tmp
        mkdir -p $TMPDIR
        CMAKEURL=""
        arch="$(uname -m)"
        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-macos-universal.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-linux-x86_64.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "aarch64" ]]; then
            CMAKEURL="https://github.com/Kitware/CMake/releases/download/v$CMAKEVER/cmake-$CMAKEVER-linux-aarch64.tar.gz"
        fi
        if [[ "$CMAKEURL" != "" ]]; then
            echo "Fetching static cmake binaries"
            cd $TMPDIR && wget $CMAKEURL && tar -xzf cmake*.tar.gz && rm cmake*.tar.gz && \
                mv cmake*/bin/* $LOCALDIR/bin/ && \
                mv cmake*/share/* $LOCALDIR/share/
        else
            echo "Failed to install static cmake. Please install it manually before proceeding."
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
       [[ -d "$NCDIR" ]]; then
    echo "libncurses appears to be installed; skipping..."
    else
    echo "libncurses not found!"
    read -p "Install ncurses (vim, vifm and htop require ncurses)? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing ncurses"
        mkdir -p $LOCALDIR
        mkdir -p $NCDIR
        rm -rf local
        mkdir -p local
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
        rm -rf local
    fi
fi

# Install vim?
if \
    [[ -f "$LOCALDIR/bin/vim" ]]; then
    echo "Vim appears to be installed locally; skipping..."
else
    echo "I highly recommend installing the latest vim locally."
    read -p "Install vim locally? (This may take a while) [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing vim"
        mkdir -p $LOCALDIR/bin
        # Couple of notes:
        # A. I disable selinux because not all the servers I'm on have it installed
        #    so I'm not going to bother.
        # B. To get my local ncurses (really ncursesw) to be recognized, I added
        #    its path to LDFLAGS and CFLAGS.
        # C. Needed to explicitly use --disable-darwin to have it build normally on
        #    mac.
        # D. Obviously installing to ~/.local/bin -- sourced in commonrc.
        # E. I added the submodule to path third_party/vim9 because third_party/vim
        #    holds all the vim plugins, and I really don't want to move submodules now.
        cd $THISDIR/third_party/vim9/ && \
            make clean && make distclean &&           \
            LDFLAGS=-L${NCDIR}/lib                    \
            CFLAGS=-I${NCDIR}/include                 \
            ./configure                               \
            --with-features=huge                      \
            --enable-terminal                         \
            --enable-multibyte                        \
            --enable-pythoninterp=dynamic             \
            --enable-python3interp=dynamic            \
            --with-tlib=ncursesw                      \
            --disable-darwin                          \
            --disable-selinux                         \
            --disable-gui                             \
            --disable-netbeans                        \
            --enable-cscope                           \
            --prefix=${LOCALDIR} &&                   \
            make && make install && make clean
        cd $THISDIR
    fi
fi

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
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-x86_64-unknown-linux-gnu.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "i686" ]]; then
            BATURL="https://github.com/sharkdp/bat/releases/download/v0.22.1/bat-v0.22.1-i686-unknown-linux-gnu.tar.gz"
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

# Install tre?
## 
if \
    [[ -f "$LOCALDIR/bin/tre" ]]; then
#    Not explicitly checking if tre is recognized because we want our minimum version satisfied
#    [[ -f "$(which tre)" ]]; then
    echo "tre appears to be installed ($(which tre)); skipping..."
else
    echo "which tre: $(which tre)"
    read -p "Install tre? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing tre"
        mkdir -p $LOCALDIR/bin
        TMPDIR=$THISDIR/tmp
        mkdir -p $TMPDIR
        mkdir -p $TMPDIR/tre
        TREURL=""
        arch="$(uname -m)"
        if [[ "$OSTYPE" == "darwin"* ]] && [[ "$arch" == "x86_64" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v0.4.0/tre-v0.4.0-x86_64-apple-darwin.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "x86_64" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v0.4.0/tre-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
        elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ "$arch" == "arm" ]]; then
            TREURL="https://github.com/dduan/tre/releases/download/v0.4.0/tre-v0.4.0-arm-unknown-linux-gnueabihf.tar.gz"
        fi
        if [[ "$TREURL" != "" ]]; then
            echo "Fetching static tre binaries"
            cd $TMPDIR && wget $TREURL && tar -xzf tre*.tar.gz -C tre/ && rm tre*.tar.gz && mv tre/tre $LOCALDIR/bin/tre
        else
            echo "Failed to install static tre. Please install it manually before proceeding."
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
        NCARG="--with-curses=$NCDIR --with-curses-name=ncursesw"
        cd $THISDIR/third_party/vifm/ && autoreconf -f -i && ./configure --prefix=$LOCALDIR $NCARG && make && make install
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

# Install htop?
## 
if \
    [[ -f "$LOCALDIR/bin/htop" ]]; then
#    Not explicitly checking if htop is recognized because we want our minimum version satisfied
#    [[ -f "$(which htop)" ]]; then
    echo "htop appears to be installed ($(which htop)); skipping..."
else
    echo "htop was not found."
    echo "which htop: $(which htop)"
    read -p "Install htop? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing htop"
        mkdir -p $LOCALDIR/bin
        cd $THISDIR/third_party/htop/ && ./autogen.sh && \
            HTOP_NCURSES6_CONFIG_SCRIPT=$NCDIR/bin/ncursesw6-config \
            LDFLAGS="-L$NCDIR/lib" \
            CPPFLAGS="-I$NCDIR/include" \
            CFLAGS="-I$NCDIR/include" \
            ./configure --prefix=$LOCALDIR \
                    && make && make install
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
rm $HOMEDIR/.bashrc2
ln -s $THISDIR/bashrc $HOMEDIR/.bashrc2
SOURCEBASHRC="[ -f $HOME/.bashrc2 ] && source $HOME/.bashrc2"
# Check if it's already appended
if grep -Fxq "$SOURCEBASHRC" $HOMEDIR/.bashrc; then
    echo "Perfect! Looks like you already installed one. Skipping appending bashrc to ~/.bashrc because it's already there!"
else
    echo "Appending bashrc to ~/.bashrc"
    echo $SOURCEBASHRC >> $HOMEDIR/.bashrc
fi

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
# Don't go removing my vifm
# rm -rf $HOMEDIR/.vifm
if ! [[ -d $HOMEDIR/.vifm ]]; then
    # cp -r $THISDIR/vifm $HOMEDIR/.vifm
    mkdir -p $HOMEDIR/.vifm
fi
rm -rf $HOMEDIR/.vifm/vifmrc
ln -s $VIFMRC $HOMEDIR/.vifm/vifmrc
VIFMFILES=("graphics" "scripts" "colors" "shell-completion" "plugins" "vim" "man" "vimfiles"
           "vifm.desktop" "vifm-help.txt" "vifm.appdata.xml")
for vifmfile in ${VIFMFILES[*]};do
    echo "Linking $vifmfile";
    rm -rf $HOMEDIR/.vifm/$vifmfile
    ln -s $THISDIR/vifm/$vifmfile $HOMEDIR/.vifm/$vifmfile
done;


# Replace the vim files
echo "Linking vim files..."
rm -r $HOMEDIR/.vim
rm -r $HOMEDIR/.vimrc
ln -s $THISDIR/vim $HOMEDIR/.vim
ln -s $THISDIR/vimrc $HOMEDIR/.vimrc
mkdir -p $HOMEDIR/.vimfiles/undodir

# Kitty
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Kitty's mac only for now
    echo "Linking kitty config"
    rm -rf $HOMEDIR/.config/kitty
    mkdir -p $HOMEDIR/.config/
    if [[ "$OSTYPE" == "darwin"* ]]; then
        ln -s $THISDIR/config/kitty.mac $HOMEDIR/.config/kitty
    fi
fi

# LSCOLORS
# Generated by vivid
# https://github.com/sharkdp/vivid
rm -r $HOMEDIR/.lscolors
ln -s $THISDIR/lscolors $HOMEDIR/.lscolors
if [[ "$OSTYPE" == "darwin"* ]] && ! [[ -f "$(which gls)" ]]; then
    echo "gls is not installed! "
    echo "Mac uses the BSD ls, so you need to have gls if you want ls colors."
    read -p "Install via brew? [y/n]: " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        brew install coreutils 
    fi
fi

# Setup oh my zsh
rm -rf $HOMEDIR/.oh-my-zsh
echo "Linking oh-my-zsh to home directory"
ln -s $THISDIR/third_party/zsh/ohmyzsh $HOMEDIR/.oh-my-zsh
rm -f $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
ln -s $THISDIR/third_party/zsh/zsh-autosuggestions $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -f $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
ln -s $THISDIR/third_party/zsh/zsh-syntax-highlighting $HOMEDIR/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 

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


# Zathura
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Zathura is mac only for now
    if ! [[ -f "$(which zathura)" ]]; then
        read -p "Install Zathura? (requires homebrew and a reboot) [y/n]: " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            ./tools/zathura.mac.sh
        fi
    fi
    echo "Linking zathura config"
    rm -rf $HOMEDIR/.config/zathura
    mkdir -p $HOMEDIR/.config/
    ln -s $THISDIR/config/zathura $HOMEDIR/.config/zathura
fi



echo "Installation complete"
