#!/usr/bin/env bash
# Remove only paths listed in the latest receipt. Never delete ~/.buzz-dev or nsec.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RECEIPT="$(ls -1t "$ROOT"/receipt/*.txt 2>/dev/null | head -1 || true)"
if [[ -z "$RECEIPT" ]]; then
  echo "no receipt; nothing to uninstall"
  exit 0
fi
echo "using $RECEIPT"
while IFS= read -r path; do
  [[ -z "$path" ]] && continue
  case "$path" in
    *agent.env|*nsec*|"$HOME/.buzz-dev"|"$HOME/.buzz-dev"/*)
      echo "skip secret-or-seat $path"
      continue
      ;;
  esac
  if [[ -e "$path" || -L "$path" ]]; then
    rm -rf "$path"
    echo "removed $path"
  fi
done <"$RECEIPT"
echo "uninstall complete (receipt kept for audit)"
