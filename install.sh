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

extract_zip() {   # $1=zip $2=dest — unzip is not universal (NixOS ships without it)
  if command -v unzip >/dev/null 2>&1; then unzip -oq "$1" -d "$2"; return; fi
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall(sys.argv[2])' "$1" "$2"; return
  fi
  if command -v bsdtar >/dev/null 2>&1; then bsdtar -xf "$1" -C "$2"; return; fi
  if command -v busybox >/dev/null 2>&1; then busybox unzip -oq "$1" -d "$2"; return; fi
  echo "No unzip tool found. On NixOS run: nix-shell -p unzip --run 'bash install.sh'  (or add pkgs.unzip)"
  exit 1
}

echo "-> Downloading Blastkit $VER ..."
mkdir -p "$DIR"
curl -fsSL "https://github.com/$REPO/releases/download/v$VER/$ASSET" -o "$DIR/.sender.zip"
extract_zip "$DIR/.sender.zip" "$DIR"
rm -f "$DIR/.sender.zip"
chmod +x "$DIR/sender"

# macOS Gatekeeper: the binary is not notarised, so clear the quarantine flag
# for this folder. Without it the first run is blocked with "cannot be opened".
if [ "$(uname -s)" = "Darwin" ]; then
  xattr -dr com.apple.quarantine "$DIR" 2>/dev/null || true
fi

if [ ! -x "$DIR/sender" ]; then
  echo "Install finished but the program is missing - re-run, or ping support."
  exit 1
fi
echo "-> Installed to $DIR"
if [ -e /etc/NIXOS ]; then
  cat <<'NIX'
Note (NixOS): this program needs the standard Linux loader, which NixOS
does not provide by default. Two ways to fix:

  one-off (no rebuild):
    nix-shell -p stdenv.cc.cc.lib zlib --run "$DIR/sender"

  permanent - add to configuration.nix, then sudo nixos-rebuild switch:
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [ stdenv.cc.cc zlib ];
NIX
fi
echo ""
echo "Start it with:  $DIR/sender"
echo "On first launch it shows your MACHINE CODE -"
echo "send that code back to the bot and your licence file lands right here."
