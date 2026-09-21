#!/bin/bash
set -e -o pipefail

if [ ! -d "$HOME/.antidote/.git" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi
