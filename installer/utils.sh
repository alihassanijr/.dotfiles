#!/usr/bin/env bash
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
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    return 0
  fi
  git submodule update --init --recursive
}

program_path() {
  # Print the resolved path of the given program (empty if not found).
  # Uses `command` rather than `which`, since `which` isn't guaranteed to exist.
  command -v "$1"
}

program_exists() {
  # Return success if the given program is on PATH.
  program_path "$1" >/dev/null 2>&1
}

fetch_package() {
  # Download a file, trying each mirror in order until one works.
  # Usage: fetch_package <output_file> <url> [more_urls...]
  # Prefers wget; falls back to curl (e.g. while bootstrapping wget itself).
  local OUTFILE=$1
  shift
  local DLURL
  for DLURL in "$@"; do
    echo "Fetching $DLURL"
    if program_exists wget; then
      wget --tries=3 --timeout=30 "$DLURL" -O "$OUTFILE" && return 0
    else
      curl -fL --retry 3 --connect-timeout 30 -o "$OUTFILE" "$DLURL" && return 0
    fi
    echo "Mirror failed, trying next: $DLURL"
  done
  echo "ERROR: all mirrors failed for $OUTFILE"
  return 1
}

build_tmpdir() {
  # Pick a build temp dir. Under BUILD_ONLY (containerized builds that ship the
  # tree) use an OS-generated tmp dir to avoid conflicts and keep $THISDIR clean;
  # otherwise use a predictable local dir under $THISDIR.
  local NAME=$1
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    mktemp -d
  else
    echo "$THISDIR/tmp_$NAME"
  fi
}

check_soft_dependency() {
  local DEP_NAME=$1         # dependency name

  if program_exists "$DEP_NAME"; then
    echo "$DEP_NAME is installed at $(program_path "$DEP_NAME")"
  else
      echo "$DEP_NAME was not found on this system. It's a soft dependency."
  fi
}

check_hard_dependency() {
  local DEP_NAME=$1         # dependency name

  if program_exists "$DEP_NAME"; then
    echo "$DEP_NAME is installed at $(program_path "$DEP_NAME")"
  else
      echo "$DEP_NAME was not found on this system, and it is a hard dependency. "
      echo "Please install it before proceeding."
      exit 1
  fi
}

check_and_install_hard_dependency() {
  local DEP_NAME=$1         # dependency name
  local INSTALL_FUNCTION=$2 # if it doesn't exist, prompt install and call this function if responded yes

  if program_exists "$DEP_NAME"; then
    echo "$DEP_NAME is installed at $(program_path "$DEP_NAME")"
  else
      echo "Local $DEP_NAME was not found. It is recommended that you install locally."
      echo "Note: this does not require sudo; just build tools."
      if [[ "$BUILD_ONLY" -eq 1 ]]; then
        REPLY="y"
      else
        read -p "Install $DEP_NAME? [y/n]: " -r
        echo ""
      fi
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          echo "Installing $DEP_NAME"
          $INSTALL_FUNCTION || {
            echo "$DEP_NAME install failed"
            if [[ "$BUILD_ONLY" -eq 1 ]]; then
              exit 1
            fi
            return 1
          }
      fi
  fi
}

check_and_install_dependency() {
  local DEP_NAME=$1         # dependency name
  local LOCAL_PATH=$2       # expect to find this path, otherwise we will assume it doesn't exist
  local INSTALL_FUNCTION=$3 # if it doesn't exist, prompt install and call this function if responded yes

  if [[ -f $LOCAL_PATH ]]; then
      echo "$DEP_NAME was found locally; skipping..."
  else
      echo "Local $DEP_NAME was not found. It is recommended that you install locally."
      echo "Note: this does not require sudo; just build tools."
      if [[ "$BUILD_ONLY" -eq 1 ]]; then
        REPLY="y"
      else
        read -p "Install $DEP_NAME? [y/n]: " -r
        echo ""
      fi
      if [[ $REPLY =~ ^[Yy]$ ]]
      then
          echo "Installing $DEP_NAME"
          $INSTALL_FUNCTION || {
            echo "$DEP_NAME install failed"
            if [[ "$BUILD_ONLY" -eq 1 ]]; then
              exit 1
            fi
            return 1
          }
      fi
  fi
}

preconfigure_dependency() {
  local DEP_NAME=$1               # dependency name
  local CONFIGURATION_FUNCTION=$2 # function to call
  echo "Pre-configuring $DEP_NAME..."
  $CONFIGURATION_FUNCTION
}

configure_dependency() {
  local DEP_NAME=$1               # dependency name
  local CONFIGURATION_FUNCTION=$2 # function to call
  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    echo "BUILD_ONLY set; skipping configuration of $DEP_NAME"
    return 0
  fi
  echo "Configuring $DEP_NAME..."
  $CONFIGURATION_FUNCTION
}

link_to_home() {
  local RC_NAME=$1          # Name
  local PATH_IN_DOTFILES=$2 # File name in .dotfiles
  local PATH_IN_HOME=$3     # Target in $HOME
  local SRC_PATH="$THISDIR/$PATH_IN_DOTFILES"
  local DST_PATH="$HOMEDIR/$PATH_IN_HOME"
  if [[ -f $SRC_PATH ]]; then
    echo "Linking $RC_NAME. Symlink $PATH_IN_DOTFILES to ~/$PATH_IN_HOME"
    [ -f "$DST_PATH" ] && rm $DST_PATH
    ln -s $SRC_PATH $DST_PATH
  fi
}

link_bin() {
  local BIN_NAME=$1         # Name
  local PATH_IN_DOTFILES=$2 # File name in .dotfiles
  local TARGET_NAME=$3      # Target in $LOCALDIR/bin
  echo "Copying $BIN_NAME. Copy $PATH_IN_DOTFILES to $LOCALDIR/bin/$TARGET_NAME"
  rm -f $LOCALDIR/bin/$TARGET_NAME
  cp -f $THISDIR/$PATH_IN_DOTFILES $LOCALDIR/bin/$TARGET_NAME

}

ensure_local_exists() {
  # Ensure expected directories exist

  # .local
  mkdir -p $LOCALDIR/
  mkdir -p $LOCALDIR/bin
  mkdir -p $LOCALDIR/man
  mkdir -p $LOCALDIR/share

  # .ncurses
  mkdir -p $NCDIR

  if [[ "$BUILD_ONLY" -eq 1 ]]; then
    return 0
  fi

  # .config
  mkdir -p $HOMEDIR/.config
}
