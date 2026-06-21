#!/bin/bash
# uv

UV_VERSION="0.11.23"

install_uv() {
  local TMPDIR=$(build_tmpdir uv)
  local PACKAGEURLS=(
      "https://releases.astral.sh/github/uv/releases/download/$UV_VERSION/uv-installer.sh"
  )
  local PACKAGE_INSTALLER_FN="uv-installer.sh"
  
  cd $THISDIR
  rm -rf $TMPDIR
  mkdir -p $TMPDIR

  cd $TMPDIR && \
      fetch_package $PACKAGE_INSTALLER_FN "${PACKAGEURLS[@]}" && \
      XDG_BIN_HOME=$LOCALDIR/bin \
      INSTALLER_NO_MODIFY_PATH=1 \
      UV_NO_MODIFY_PATH=1 \
      bash $PACKAGE_INSTALLER_FN \
        --verbose

  if [ $? -ne 0 ]; then
      echo "uv build failed."
      cd $THISDIR
      rm -rf $TMPDIR
      return 1
  fi

  cd $THISDIR
  rm -rf $TMPDIR
}

preconfigure_uv() {
  if [ ! -d $PYTHON_BASE_VENV_DIR ]; then
    echo "Setting up base python environment at $PYTHON_BASE_VENV_DIR"
    uv venv $PYTHON_BASE_VENV_DIR --python 3.12
  else
    echo "Base python environment already set up at $PYTHON_BASE_VENV_DIR, skipping..."
  fi
}
