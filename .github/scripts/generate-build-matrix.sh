#!/usr/bin/env bash
set -euo pipefail

kind="${1:-packages}"

store_args=()
if [ -n "${NIX_MATRIX_STORE:-}" ]; then
  store_args=(--store "$NIX_MATRIX_STORE")
elif [ -z "${CI:-}" ]; then
  matrix_store="$(mktemp -d -t nix-matrix-store.XXXXXXXX)"
  store_args=(--store "$matrix_store")
  echo "Using isolated Nix store for dry-run checks: $matrix_store" >&2
fi

nix_eval() {
  nix "${store_args[@]}" eval "$@"
}

nix_dry_run() {
  nix "${store_args[@]}" build --dry-run --no-link --accept-flake-config "$@"
}

case "$kind" in
packages)
  output_name="targets"
  has_output_name="has_targets"
  cached_message="All targets are substitutable! Skipping matrix."
  uncached_message="Found targets that need builds"
  entries="$(nix_eval .#packages.x86_64-linux --apply builtins.attrNames --json | jq -c 'map("packages.x86_64-linux.\(.)")')"

  flake_attr_for_entry() {
    echo "$1"
  }
  ;;
hosts)
  output_name="hosts"
  has_output_name="has_hosts"
  cached_message="All hosts are substitutable! Skipping matrix."
  uncached_message="Found hosts that need builds"
  entries='["testvm","nixwsl","nixavell"]'

  flake_attr_for_entry() {
    echo "nixosConfigurations.${1}.config.system.build.toplevel"
  }
  ;;
*)
  echo "Usage: $0 [packages|hosts]" >&2
  exit 2
  ;;
esac

needs_build() {
  local flake_attr="$1"
  local output

  if ! output="$(nix_dry_run ".#${flake_attr}" 2>&1)"; then
    echo "$output" >&2
    echo "Dry-run failed for .#${flake_attr}; including it in the build matrix." >&2
    return 0
  fi

  if grep -Eq 'derivations? will be built:' <<<"$output"; then
    return 0
  fi

  return 1
}

case "$kind" in
packages)
  mapfile -t entry_list < <(echo "$entries" | jq -r '.[]')
  package_drv_paths="$(nix_eval .#packages.x86_64-linux --apply 'packages: builtins.mapAttrs (_: package: package.drvPath) packages' --json)"
  flake_attrs=()
  for entry in "${entry_list[@]}"; do
    flake_attrs+=(".#$(flake_attr_for_entry "$entry")")
  done

  dry_run_output="$(nix_dry_run "${flake_attrs[@]}" 2>&1 || true)"
  built_drv_paths="$(grep -E '^  /nix/store/.+[.]drv$' <<<"$dry_run_output" | sed 's/^  //' || true)"
  uncached_entries='[]'

  for entry in "${entry_list[@]}"; do
    package_name="${entry#packages.x86_64-linux.}"
    drv_path="$(echo "$package_drv_paths" | jq -r --arg name "$package_name" '.[$name] // empty')"
    if [ -n "$drv_path" ] && grep -Fxq "$drv_path" <<<"$built_drv_paths"; then
      uncached_entries="$(echo "$uncached_entries" | jq -c --arg entry "$entry" '. + [$entry]')"
    fi
  done
  ;;
hosts)
  uncached_entries='[]'
  while IFS= read -r entry; do
    flake_attr="$(flake_attr_for_entry "$entry")"
    if needs_build "$flake_attr"; then
      uncached_entries="$(echo "$uncached_entries" | jq -c --arg entry "$entry" '. + [$entry]')"
    fi
  done < <(echo "$entries" | jq -r '.[]')
  ;;
esac

if [ "$uncached_entries" = "[]" ]; then
  echo "$cached_message"
  entries_output='["dummy"]'
  has_entries_output='false'
else
  echo "$uncached_message: $uncached_entries"
  entries_output="$uncached_entries"
  has_entries_output='true'
fi

if [ -n "${GITHUB_OUTPUT:-}" ]; then
  echo "${output_name}=${entries_output}" >>"$GITHUB_OUTPUT"
  echo "${has_output_name}=${has_entries_output}" >>"$GITHUB_OUTPUT"
else
  echo "${output_name}=${entries_output}"
  echo "${has_output_name}=${has_entries_output}"
fi
