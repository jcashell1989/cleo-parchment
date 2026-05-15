#!/usr/bin/env bash
# Install Pi Coding Agent themes from this repo into ~/.pi/agent/themes/
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${PI_THEMES_DIR:-$HOME/.pi/agent/themes}"
mkdir -p "$DEST"
cp "$ROOT/pi/cleo-parchment.json" "$ROOT/pi/cleo-parchment-dark.json" "$DEST/"
echo "Installed cleo-parchment themes to $DEST"

if defaults read -g AppleInterfaceStyle &>/dev/null; then
  THEME=cleo-parchment-dark
else
  THEME=cleo-parchment
fi

SETTINGS="$HOME/.pi/agent/settings.json"
if [ -f "$SETTINGS" ] && command -v python3 >/dev/null; then
  python3 - "$SETTINGS" "$THEME" <<'PY'
import json, sys
path, theme = sys.argv[1], sys.argv[2]
with open(path) as f:
    data = json.load(f)
data["theme"] = theme
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print(f"Set theme to {theme} in {path}")
PY
else
  echo "Set \"theme\": \"$THEME\" in ~/.pi/agent/settings.json"
fi
