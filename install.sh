#!/usr/bin/env bash
# Blastkit one-liner installer (Linux/macOS):
#   curl -fsSL https://raw.githubusercontent.com/evilsonnet/bulk-sender/main/install.sh | bash && ~/.blastkit/sender
set -e
REPO="evilsonnet/bulk-sender"
VER="1.0.0"
DIR="$HOME/.blastkit"

case "$(uname -s)" in
  Linux)  ASSET="sender-$VER-linux.zip" ;;
  Darwin) echo "macOS build is on its way - ping support and we will sort you out."; exit 1 ;;
  *) echo "Unsupported system: $(uname -s)"; exit 1 ;;
esac

echo "-> Downloading Blastkit $VER ..."
mkdir -p "$DIR"
curl -fsSL "https://github.com/$REPO/releases/download/v$VER/$ASSET" -o "$DIR/.sender.zip"
unzip -oq "$DIR/.sender.zip" -d "$DIR"
rm -f "$DIR/.sender.zip"
chmod +x "$DIR/sender"

echo "-> Installed to $DIR"
echo ""
echo "Start it with:  $DIR/sender"
echo "On first launch it shows your MACHINE CODE -"
echo "send that code back to the bot and your licence file lands right here."
