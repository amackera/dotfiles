#!/usr/bin/env bash
# Sets up a Mac from this repo. Safe to re-run.
#
# Usage: ./install.sh [step ...]
# Steps: brew dotfiles runtimes emacs (default: all, in that order)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREW=/opt/homebrew/bin/brew

if [ -x "$BREW" ]; then
  eval "$("$BREW" shellenv)"
fi

step_brew() {
  if [ ! -x "$BREW" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$("$BREW" shellenv)"
  fi
  # Homebrew refuses to load third-party taps until they are trusted.
  brew tap d12frosted/emacs-plus
  brew trust --tap d12frosted/emacs-plus
  # --no-upgrade: re-running only installs what is missing.
  brew bundle install --no-upgrade --file="$DOTFILES/Brewfile"
}

step_dotfiles() {
  # Copies every tracked file into $HOME. An existing file that differs is
  # kept alongside as <name>.pre-dotfiles.
  git -C "$DOTFILES" ls-files | grep -vE '^(README\.md|Brewfile|install\.sh)$' |
    while IFS= read -r f; do
      mkdir -p "$HOME/$(dirname "$f")"
      if [ -e "$HOME/$f" ] && ! cmp -s "$DOTFILES/$f" "$HOME/$f"; then
        cp "$HOME/$f" "$HOME/$f.pre-dotfiles"
        echo "backed up ~/$f to ~/$f.pre-dotfiles"
      fi
      cp "$DOTFILES/$f" "$HOME/$f"
    done
}

step_runtimes() {
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  cut -d' ' -f1 "$HOME/.tool-versions" |
    while IFS= read -r plugin; do
      asdf plugin list 2>/dev/null | grep -qx "$plugin" || asdf plugin add "$plugin"
    done
  # Erlang and Python compile from source, so this takes a while.
  (cd "$HOME" && asdf install)
  (cd "$HOME" && mix local.hex --force && mix local.rebar --force)
}

step_emacs() {
  if [ ! -d "$HOME/.emacs.d" ]; then
    git clone https://github.com/amackera/emacs.d.git "$HOME/.emacs.d"
  fi
}

steps=("$@")
if [ ${#steps[@]} -eq 0 ]; then
  steps=(brew dotfiles runtimes emacs)
fi

for step in "${steps[@]}"; do
  if ! declare -F "step_$step" >/dev/null; then
    echo "unknown step: $step (expected: brew dotfiles runtimes emacs)" >&2
    exit 1
  fi
  echo "==> $step"
  "step_$step"
done

echo "Done. Open a new shell to pick up the changes."
