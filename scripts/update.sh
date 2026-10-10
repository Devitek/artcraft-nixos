#!/usr/bin/env bash
# Refresh _sources/ from upstream via nvfetcher and print a Markdown summary of the
# per-app version bumps (one line per app) to stdout.
#
# Requirements (provided by `nix develop`): nvfetcher, jq.
# Optional: $GITHUB_TOKEN (recommended, avoids GitHub API rate limits).
#
# Usage: nix develop .#default --command bash scripts/update.sh
set -euo pipefail
cd "$(dirname "$0")/.."

gen="_sources/generated.json"

# app -> version map (both arches share a version, so de-duplicate per app).
snapshot() {
  [ -f "$gen" ] || return 0
  jq -r 'to_entries[] | "\(.key)\t\(.value.version)"' "$gen" \
    | sed -E 's/-(x86_64|aarch64)-linux\t/\t/' \
    | sort -u
}

before="$(snapshot)"

keyfile="$(mktemp)"
trap 'rm -f "$keyfile"' EXIT
printf '[keys]\ngithub = "%s"\n' "${GITHUB_TOKEN:-}" >"$keyfile"

# Track latest releases and refresh hashes. Quiet on stdout (progress on stderr).
nvfetcher -c nvfetcher.toml -k "$keyfile" 1>&2

after="$(snapshot)"

declare -A OLD NEW
while IFS=$'\t' read -r app ver; do
  [ -n "${app:-}" ] && OLD["$app"]="$ver"
done <<<"$before"
while IFS=$'\t' read -r app ver; do
  [ -n "${app:-}" ] && NEW["$app"]="$ver"
done <<<"$after"

# Emit a sorted Markdown bullet per changed app.
for app in "${!NEW[@]}"; do
  old="${OLD[$app]:-new}"
  new="${NEW[$app]}"
  [ "$old" != "$new" ] && printf '%s\t- %s: %s → %s\n' "$app" "$app" "$old" "$new"
done | sort | cut -f2-
