#!/bin/bash
# Installer script utilities
# Author: Ali Hassani (@alihassanijr)


assert_dotfiles_in_home() {
  if [[ ! -d $THISDIR ]]
  then
      echo "Please place .dotfiles in $HOME"
      exit 1
  fi
}

update_submodules() {
  git submodule update --init --recursive
}

check_soft_dependency() {
  DEP_NAME=$1         # dependency name

  if [[ -f "$(which $DEP_NAME)" ]]; then
    echo "$DEP_NAME is installed at $(which $DEP_NAME)"
  else
      echo "$DEP_NAME was not found on this system. It's a soft dependency."
  fi
}

check_hard_dependency() {
  DEP_NAME=$1         # dependency name

  if [[ -f "$(which $DEP_NAME)" ]]; then
    echo "$DEP_NAME is installed at $(which $DEP_NAME)"
  else
      echo "$DEP_NAME was not found on this system, and it is a hard dependency. "
      echo "Please install it before proceeding."
      exit 1
  fi
}

check_and_install_hard_dependency() {
  DEP_NAME=$1         # dependency name
  INSTALL_FUNCTION=$2 # if it doesn't exist, prompt install and call this function if responded yes

  if [[ -f "$(which $DEP_NAME)" ]]; then
    echo "$DEP_NAME is installed at $(which $DEP_NAME)"
  else
      echo "Local $DEP_NAME was not found. It is recommended that you install locally."
      echo "Note: this does not require sudo; just build tools."
      read -p "Install $DEP_NAME? [y/n]: " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          echo "Installing $DEP_NAME"
          $INSTALL_FUNCTION
      fi
  fi
}

check_and_install_dependency() {
  DEP_NAME=$1         # dependency name
  LOCAL_PATH=$2       # expect to find this path, otherwise we will assume it doesn't exist
  INSTALL_FUNCTION=$3 # if it doesn't exist, prompt install and call this function if responded yes

  if [[ -f $LOCAL_PATH ]]; then
      echo "$DEP_NAME was found locally; skipping..."
  else
      echo "Local $DEP_NAME was not found. It is recommended that you install locally."
      echo "Note: this does not require sudo; just build tools."
      read -p "Install $DEP_NAME? [y/n]: " -n 1 -r
      echo ""
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          echo "Installing $DEP_NAME"
          $INSTALL_FUNCTION
      fi
  fi
}

configure_dependency() {
  DEP_NAME=$1               # dependency name
  CONFIGURATION_FUNCTION=$2 # function to call
  echo "Configuring $DEP_NAME..."
  $CONFIGURATION_FUNCTION
}

link_to_home() {
  RC_NAME=$1          # Name
  PATH_IN_DOTFILES=$2 # File name in .dotfiles
  PATH_IN_HOME=$3     # Target in $HOME
  echo "Linking $RC_NAME. Symlink $PATH_IN_DOTFILES to ~/$PATH_IN_HOME"
  rm $HOMEDIR/$PATH_IN_HOME
  ln -s $THISDIR/$PATH_IN_DOTFILES $HOMEDIR/$PATH_IN_HOME

}

link_bin() {
  BIN_NAME=$1         # Name
  PATH_IN_DOTFILES=$2 # File name in .dotfiles
  TARGET_NAME=$3      # Target in $LOCALDIR/bin
  echo "Linking $BIN_NAME. Symlink $PATH_IN_DOTFILES to ~/.local/bin/$TARGETNAME"
  rm -f $LOCALDIR/bin/$TARGET_NAME
  ln -s $THISDIR/$PATH_IN_DOTFILES $LOCALDIR/bin/$TARGET_NAME

}

ensure_local_exists() {
  # Ensure expected directories exist
  mkdir -p $LOCALDIR/
  mkdir -p $LOCALDIR/bin
  mkdir -p $LOCALDIR/man
  mkdir -p $LOCALDIR/share
  mkdir -p $HOMEDIR/.config
  mkdir -p $NCDIR
}
