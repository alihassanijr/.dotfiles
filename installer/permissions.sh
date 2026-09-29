#!/usr/bin/env bash
# Permissions: make private directories / files user-only
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/


make_user_only_dir() {
  # chmod 700 the given directory if it exists. Both the test and chmod follow
  # symlinks, so linked dirs (e.g. ~/.vim -> $THISDIR/vim) get their target fixed.
  local DIR=$1
  if [[ -d $DIR ]]; then
    echo "Setting user-only permissions (700) on $DIR"
    chmod 700 "$DIR"
  elif [[ -L $DIR ]]; then
    echo "WARNING: $DIR is a dangling symlink (-> $(readlink "$DIR")); skipping."
  else
    echo "$DIR does not exist; skipping."
  fi
}

make_user_only_file() {
  # chmod 600 the given file if it exists. Same symlink behavior as above.
  local FILE=$1
  if [[ -f $FILE ]]; then
    echo "Setting user-only permissions (600) on $FILE"
    chmod 600 "$FILE"
  elif [[ -L $FILE ]]; then
    echo "WARNING: $FILE is a dangling symlink (-> $(readlink "$FILE")); skipping."
  else
    echo "$FILE does not exist; skipping."
  fi
}

fix_permissions() {
  echo "Fixing permissions..."

  # Dotfiles and program trees
  make_user_only_dir "$THISDIR"
  make_user_only_dir "$PROGRAMS_PATH"
  make_user_only_dir "$LOCALDIR"
  make_user_only_dir "$NCDIR"
  make_user_only_dir "$BREWDIR"
  make_user_only_dir "$FZF_DIR/.fzf"

  # Editors / tools configured by the installer (see dependencies/*.sh configure_* fns)
  make_user_only_dir "$HOMEDIR/.vim"
  make_user_only_dir "$HOMEDIR/.vimfiles"
  make_user_only_dir "$HOMEDIR/.vifm"
  make_user_only_dir "$HOMEDIR/.fzf"
  make_user_only_dir "$HOMEDIR/.config"

  # Coding agents: configs, memory, project/session history
  make_user_only_dir "$HOMEDIR/.claude"
  make_user_only_dir "$HOMEDIR/.codex"
  make_user_only_file "$HOMEDIR/.claude.json"

  # Just for being safe
  make_user_only_dir "$HOMEDIR/.ssh"
  make_user_only_dir "$HOMEDIR/.gnupg"
  make_user_only_dir "$HOMEDIR/.docker"
  make_user_only_dir "$HOMEDIR/.cache"
}
