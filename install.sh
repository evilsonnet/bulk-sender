#!/usr/bin/env bash
# Blastkit one-liner installer:
#   curl -fsSL https://raw.githubusercontent.com/evilsonnet/bulk-sender/main/install.sh | bash && ~/.blastkit/sender
set -e
REPO="evilsonnet/bulk-sender"
VER="1.0.0"
DIR="$HOME/.blastkit"

case "$(uname -s)" in
  Linux)  ASSET="sender-$VER-linux.zip" ;;
  Darwin)
    if [ "$(uname -m)" = "arm64" ]; then
      ASSET="sender-$VER-macos-arm64.zip"
    else
      echo "Intel Mac: no build for x86_64 yet - ping support and we will sort you out."
      exit 1
    fi
    ;;
  *) echo "Unsupported system: $(uname -s)"; exit 1 ;;
esac

echo "-> Downloading Blastkit $VER ..."
mkdir -p "$DIR"
curl -fsSL "https://github.com/$REPO/releases/download/v$VER/$ASSET" -o "$DIR/.sender.zip"
unzip -oq "$DIR/.sender.zip" -d "$DIR"
rm -f "$DIR/.sender.zip"
chmod +x "$DIR/sender"

# macOS Gatekeeper: the binary is not notarised, so clear the quarantine flag
# for this folder. Without it the first run is blocked with "cannot be opened".
if [ "$(uname -s)" = "Darwin" ]; then
  xattr -dr com.apple.quarantine "$DIR" 2>/dev/null || true
fi

echo "-> Installed to $DIR"
echo ""
echo "Start it with:  $DIR/sender"
echo "On first launch it shows your MACHINE CODE -"
echo "send that code back to the bot and your licence file lands right here."
