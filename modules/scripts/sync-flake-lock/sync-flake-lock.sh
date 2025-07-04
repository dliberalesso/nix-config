#!/usr/bin/env bash

TARGET="github:dliberalesso/nix-config"

echo "[INFO] Fetching lock contents from ($TARGET)"
METADATA=$(nix flake metadata --json $TARGET)

rev() {
  echo "${METADATA}" | jq -r ".locks.nodes.\"$1\".locked.rev"
}

echo "[INFO] Updating local lock file"

nix flake update --commit-lock-file \
  --override-input 'nixpkgs' \
    "github:nixos/nixpkgs/$(rev 'nixpkgs')" \
  --override-input 'flake-parts' \
    "github:hercules-ci/flake-parts/$(rev 'flake-parts')" \
  --override-input 'flake-root' \
    "github:srid/flake-root/$(rev 'flake-root')" \
  --override-input 'git-hooks' \
    "github:cachix/git-hooks.nix/$(rev 'git-hooks')" \
  --override-input 'import-tree' \
    "github:vic/import-tree/$(rev 'import-tree')" \
  --override-input 'make-shell' \
    "github:nicknovitski/make-shell/$(rev 'make-shell')" \
  --override-input 'treefmt-nix' \
    "github:numtide/treefmt-nix/$(rev 'treefmt-nix')"

echo "[INFO] Done"
