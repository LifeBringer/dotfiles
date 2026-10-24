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
exec sudo -H "$DARWIN_REBUILD" switch --flake "$DIR#archlinux"
