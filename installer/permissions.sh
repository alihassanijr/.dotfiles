#!/usr/bin/env bash
# Permissions: make private directories / files user-only
# Author: Ali Hassani (@alihassanijr)
# NOTE: this should be sourced from ./dotfiles/


make_private_dir() {
  # chmod 700 the given directory if it exists. Both the test and chmod follow
  # symlinks, so linked dirs (e.g. ~/.vim -> $THISDIR/config/vim) get their target fixed.
  local DIR=$1
  if [[ -d $DIR ]]; then
    note "Setting $DIR as private (700)"
    chmod 700 "$DIR"
  elif [[ -L $DIR ]]; then
    warn "WARNING: $DIR is a dangling symlink (-> $(readlink "$DIR")); skipping."
  else
    dim "$DIR does not exist; skipping."
  fi
}

make_private_dir_private_files() {
  # chmod recursively 700 the given directory if it exists, 600 on files.
  local DIR=$1
  if [[ -d $DIR ]]; then
    note "Setting $DIR as private (700, with 600 for files)"
    chmod -R u=rwX,go= "$DIR"
  elif [[ -L $DIR ]]; then
    warn "WARNING: $DIR is a dangling symlink (-> $(readlink "$DIR")); skipping."
  else
    dim "$DIR does not exist; skipping."
  fi
}

make_private_file() {
  # chmod 600 the given file if it exists. Same symlink behavior as above.
  local FILE=$1
  if [[ -f $FILE ]]; then
    note "Setting user-only permissions (600) on $FILE"
    chmod 600 "$FILE"
  elif [[ -L $FILE ]]; then
    warn "WARNING: $FILE is a dangling symlink (-> $(readlink "$FILE")); skipping."
  else
    dim "$FILE does not exist; skipping."
  fi
}

fix_permissions() {
  echo "Fixing permissions..."

  # Dotfiles and program trees
  make_private_dir "$THISDIR"
  make_private_dir "$PROGRAMS_PATH"
  make_private_dir "$LOCALDIR"
  make_private_dir "$NCDIR"
  make_private_dir "$BREWDIR"
  make_private_dir "$FZF_DIR/.fzf"

  # Editors / tools configured by the installer (see dependencies/*.sh configure_* fns)
  make_private_dir_private_files "$HOMEDIR/.vim"
  make_private_dir_private_files "$HOMEDIR/.vimfiles"
  make_private_dir_private_files "$HOMEDIR/.vifm"
  make_private_dir_private_files "$HOMEDIR/.config"

  # Coding agents: configs, memory, project/session history
  make_private_dir "$HOMEDIR/.claude"
  make_private_dir "$HOMEDIR/.codex"
  make_private_file "$HOMEDIR/.claude.json"

  # Just for being safe
  make_private_dir_private_files "$HOMEDIR/.ssh"
  make_private_dir "$HOMEDIR/.gnupg"
  make_private_dir "$HOMEDIR/.docker"
  make_private_dir "$HOMEDIR/.cache"

  # Histfile backups -- to misquote a great man: "I cannot live without [histfiles]!"
  make_private_dir_private_files "$HOMEDIR/.histfiles"
}
