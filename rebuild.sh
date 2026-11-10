#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
NIX_BIN="$(command -v nix)"
DARWIN_REBUILD="$(command -v darwin-rebuild || true)"
if [[ -z "$DARWIN_REBUILD" ]]; then
  DARWIN_REBUILD=/nix/var/nix/profiles/system/sw/bin/darwin-rebuild
fi
if [[ ! -x "$DARWIN_REBUILD" ]]; then
  echo "error: darwin-rebuild is not installed; bootstrap nix-darwin first" >&2
  exit 1
fi
ln -sfn "$DIR" ~/.dotfiles
# pi-bin points at upstream's newest release, so re-lock it on every rebuild.
# flake.lock is root-owned, hence sudo. Offline, keep the locked version.
sudo -H "$NIX_BIN" flake update pi-bin --flake "$DIR" \
  || echo "warning: could not check for a newer pi release; keeping the locked one" >&2
# The axi CLIs that the Claude SessionStart hooks run. Always take @latest so
# they never go stale; runs as the user (not sudo) into a user-owned prefix
# that home.nix puts on PATH. Offline, keep the installed versions.
NPM_BIN="$(command -v npm || true)"
if [[ -n "$NPM_BIN" ]]; then
  "$NPM_BIN" install -g --prefix "$HOME/.local/share/axi" \
    gh-axi@latest chrome-devtools-axi@latest lavish-axi@latest \
    || echo "warning: could not update the axi CLIs; keeping the installed ones" >&2
else
  echo "warning: npm not found; skipping the axi CLI install" >&2
fi
# The headless work Mac takes its own configuration; every other Mac takes
# the shared one.
case "$(scutil --get LocalHostName)" in
  LeenaAi*) HOST=leenaai ;;
  *) HOST=archlinux ;;
esac
exec sudo -H "$DARWIN_REBUILD" switch --impure --flake "$DIR#$HOST"
