#!/bin/bash
set -e -o pipefail

if [ "${NVIM_SKIP_INSTALL_PLUGINS:-0}" = 1 ] || ! command -v nvim >/dev/null 2>&1; then
  exit 0
fi

python_cmd=$(command -v python3 || true)
if [ -z "$python_cmd" ] || ! "$python_cmd" -c 'import sys; sys.exit(sys.version_info < (3, 9))'; then
  echo 'Python 3.9+ is required to install pylsp-rope' >&2
  exit 1
fi

nvim_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
venv="$nvim_data_dir/pylsp-rope"
if [ ! -x "$venv/bin/python" ] || ! "$venv/bin/python" -m pip --version >/dev/null 2>&1; then
  "$python_cmd" -m venv --clear "$venv"
fi

if ! "$venv/bin/python" -c '
import importlib.metadata as metadata
import pylsp_rope.plugin

assert metadata.version("python-lsp-server") == "1.15.0"
assert metadata.version("pylsp-rope") == "0.1.17"
' >/dev/null 2>&1; then
  "$venv/bin/python" -m pip install --disable-pip-version-check \
    --index-url https://pypi.org/simple \
    'python-lsp-server==1.15.0' 'pylsp-rope==0.1.17'
fi
