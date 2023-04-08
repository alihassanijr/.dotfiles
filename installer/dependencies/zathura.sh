#!/bin/bash
# Zathura
# Document viewer

install_zathura() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Install Zathura and its PDF module on Mac
        # Requires a reboot


        ##################################################
        ###################### DBUS ######################
        ##################################################
        echo "Installing dbus via Homebrew"
        echo "Zathura ran fine without dbus and does not explicitly require it,"
        echo "but VimTeX requires it in order to use Zathura as the PDF viewer."
        brew reinstall dbus

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
        sed -i -e "s|\(<auth>\)EXTERNAL\(</auth>\)|\1DBUS_COOKIE_SHA1\2|" $DBUSSESSIONCONF

        echo "Starting dbus"
        brew services start d-bus
        brew services info d-bus

        echo "Did dbus start?"
        read -p " [y/n]: " -n 1 -r
        echo ""
        if ! [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo "Please make sure dbus starts before proceeding."
            echo "You do have to reboot once to get it working."
            echo "Try both `brew services start d-bus` and `brew services start dbus`."
            exit 1;
        fi

        ##################################################
        ###################### GTK+ ######################
        ##################################################
        echo "Installing GTK+3, magic, and poppler"

        brew install gtk+3 libmagic gtk-mac-integration poppler

        ##################################################
        #################### zathura #####################
        ##################################################
        brew tap zegervdv/zathura
        brew install girara --HEAD
        brew install zathura --HEAD --with-synctex
        brew install zathura-pdf-poppler

        mkdir -p $(brew --prefix zathura)/lib/zathura
        ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib

        echo "If you are sourcing my `commonrc` file, you should be okay and don't have to do anything."
        echo "Otherwise:"
        echo "Please add this to your bashrc/zshrc:"
        echo "I keep a separate file for common things I'd want in both bashrc and zshrc,"
        echo "and I don't want it appended multiple times,"
        echo "and I'm too lazy..."
        echo ""
        echo "export DBUS_SESSION_BUS_ADDRESS=\"unix:path=\$DBUS_LAUNCHD_SESSION_BUS_SOCKET\""
        echo ""
        echo "Don't forget to reboot to get DBUS working."
    else
        echo "Error: I can't build zathura from source yet. Quitting..."
        exit 1
    fi
}

configure_zathura() {
    # Zathura config
    rm -rf $HOMEDIR/.config/zathura
    ln -s $THISDIR/config/zathura $HOMEDIR/.config/zathura
}

