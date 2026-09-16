#!/usr/bin/env bash
# extras-kit install. Never mint. Never copy nsec. Receipt every write.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY=0
[[ "${1:-}" == "--dry-run" ]] && DRY=1
HOST="$(hostname -s 2>/dev/null || hostname)"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
RECEIPT_DIR="$ROOT/receipt"
RECEIPT="$RECEIPT_DIR/${STAMP}-${HOST}.txt"
EXTRAS_HINT="${EXTRAS_ROOT:-}"
if [[ -z "$EXTRAS_HINT" ]]; then
  for cand in "$ROOT/../buzz-origin-plus" "$ROOT/../buzz"; do
    if [[ -d "$cand/scripts/visitor" ]]; then
      EXTRAS_HINT="$cand"
      break
    fi
  done
fi

say() { printf '%s\n' "$*"; }
do_write() {
  local path="$1"
  if [[ "$DRY" == "1" ]]; then
    say "DRY would write $path"
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  printf '%s\n' "$path" >>"$RECEIPT"
}

say "extras-kit install host=$HOST dry=$DRY"
say "refuse: mint, nsec, extra_channels+feed, curl|bash, compile on deploy host"

if [[ -z "$EXTRAS_HINT" || ! -d "$EXTRAS_HINT/scripts/visitor" ]]; then
  say "visitor kit not found. Set EXTRAS_ROOT to the extras checkout, or clone Trevongit/buzz branch feat/origin-plus-enhancements."
  [[ "$DRY" == "1" ]] && exit 0
  exit 1
fi

if [[ "$DRY" == "1" ]]; then
  say "DRY would copy visitor kit via bring.sh from $EXTRAS_HINT"
  say "DRY would write receipt $RECEIPT"
  say "DRY would not mint, not sit inbox/presence (human/agent after seats exist)"
  exit 0
fi

mkdir -p "$RECEIPT_DIR"
: >"$RECEIPT"
say "receipt $RECEIPT"

# bring.sh copies skills only; record destination skill dirs if present
bash "$EXTRAS_HINT/scripts/visitor/bring.sh" || true
for d in "$HOME/.grok/skills/use-buzz" "$HOME/.grok/skills/visitor-collab" \
         "$HOME/.codex/skills/buzz-visitor" "$HOME/.agy/skills/buzz-visitor"; do
  [[ -d "$d" ]] && printf '%s\n' "$d" >>"$RECEIPT"
done
say "done. sit inbox/presence only after a seat exists. uninstall: ./uninstall.sh"
