#!/bin/bash
# Installs the Flutter SDK in Claude Code cloud sessions so the app can be built and tested.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_VERSION="3.47.7"
FLUTTER_DIR="/opt/flutter"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  curl -sSL -o /tmp/flutter.tar.xz \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  tar -xf /tmp/flutter.tar.xz -C /opt
  rm /tmp/flutter.tar.xz
fi
git config --global --add safe.directory "$FLUTTER_DIR"

CHROME="$(ls /opt/pw-browsers/chromium*/chrome-linux*/chrome 2>/dev/null | head -1 || true)"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$FLUTTER_DIR/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
  [ -n "$CHROME" ] && echo "export CHROME_EXECUTABLE=\"$CHROME\"" >> "$CLAUDE_ENV_FILE"
fi

"$FLUTTER_DIR/bin/flutter" --disable-analytics >/dev/null 2>&1 || true
"$FLUTTER_DIR/bin/flutter" precache --web >/dev/null 2>&1 || true

if [ -f pubspec.yaml ]; then
  "$FLUTTER_DIR/bin/flutter" pub get
fi
