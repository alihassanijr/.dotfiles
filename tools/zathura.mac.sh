#!/bin/bash

THISDIR=$(pwd)
WORKDIR=$THISDIR/tmp/


##################################################
###################### DBUS ######################
##################################################
echo "Installing dbus via Homebrew"
echo "Zathura ran fine without dbus and does not explicitly require it,"
echo "but VimTeX requires it in order to use Zathura as the PDF viewer."
brew install dbus

echo "Configuring DBUS"
DBUSSESSIONCONF="/usr/local/opt/dbus/share/dbus-1/session.conf"
if ! [[ -f $DBUSSESSIONCONF ]]; then
    DBUSSESSIONCONF="/opt/homebrew/opt/dbus/share/dbus-1/session.conf"
fi
if ! [[ -f $DBUSSESSIONCONF ]]; then
    echo "Could not find dbus's session.conf. Please set it manually in this script."
    echo "Look up DBUSSESSIONCONF"
    exit 1;
fi
sed -i -e "s|\(<auth>\)EXTERNAL\(</auth>\)|\1DBUS_COOKIE_SHA1\2|" /usr/local/opt/dbus/share/dbus-1/session.conf

echo "Starting dbus"
brew services start d-bus

echo "Did dbus start?"
read -p " [y/n]: " -n 1 -r
echo ""
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Please make sure dbus starts before proceeding."
    echo "Try both `brew services start d-bus` and `brew services start dbus`."
    exit 1;
fi

echo "Please add this to your bashrc/zshrc:"
echo "I keep a separate file for common things I'd want in both bashrc and zshrc,"
echo "and I don't want it appended multiple times,"
echo "and I'm too lazy..."
echo ""
echo "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=\$DBUS_LAUNCHD_SESSION_BUS_SOCKET\""
echo ""


##################################################
###################### GTK+ ######################
##################################################
echo "Installing GTK+3, magic, and poppler"

brew install gtk+3 libmagic gtk-mac-integration poppler


##################################################
################ meson and ninja #################
##################################################
echo "Installing meson and ninja via pip"

pip3 install meson ninja

echo "Setting up working directory"
if [[ -d $WORKDIR ]]; then
    echo "Please make sure $WORKDIR does not exist before proceeding."
    exit 1;
fi
mkdir -p $WORKDIR


##################################################
##################### girara #####################
##################################################
echo "Building girara from source"
cd $WORKDIR && \
    git clone https://git.pwmt.org/pwmt/girara.git && \
    cd girara && \
    git checkout --track -b developp origin/develop && \
    mkdir build && \
    meson build && \
    cd build &&
    ninja &&
    ninja install


##################################################
#################### zathura #####################
##################################################
echo "Building zathura from source"
cd $WORKDIR && \
    git clone https://git.pwmt.org/pwmt/zathura.git && \
    cd zathura && \
    git checkout --track -b developp origin/develop && \
    mkdir build && \
    meson build && \
    cd build &&
    ninja &&
    ninja install

echo "Building zathura-pdf-poppler from source"
cd $WORKDIR && \
    git clone https://github.com/pwmt/zathura-pdf-poppler && \
    cd zathura-pdf-poppler && \
    mkdir build && \
    meson build && \
    cd build &&
    ninja &&
    ninja install

echo "Cleaning up"
rm -rf $WORKDIR
