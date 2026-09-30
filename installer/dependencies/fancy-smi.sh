#!/usr/bin/env bash
# fancy-smi: alternative to nvidia-smi
# Installed with uv into the base python venv; resolves through the venv's bin (activated by
# commonrc). Depends on uv and the base venv (ensure_uv).

FANCY_SMI_VERSION="0.1"

install_fancy_smi() {
  uv pip install --python $PYTHON_BASE_VENV_DIR fancy-smi==$FANCY_SMI_VERSION

  if [ $? -ne 0 ]; then
    echo "fancy-smi install failed."
    return 1
  fi
}
