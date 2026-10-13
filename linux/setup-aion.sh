#!/usr/bin/env bash
# Set up Aion 1.9 on Linux: Wine 11.0 staging, the D3DX9 and D3DCompiler DLLs
# its shaders need, the launcher, and an app-menu entry. Run it once with your
# Aion 1.9 client in $AION_DIR (default ~/Games/Aion), then start Aion from the
# app launcher or by running `aion`. Everything is downloaded with a pinned
# SHA-256 and stays in your home directory; nothing needs root.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GAME_DIR="${AION_DIR:-$HOME/Games/Aion}"
WINE_NAME="wine-11.0-staging-amd64-wow64"
WINE_URL="https://github.com/Kron4ek/Wine-Builds/releases/download/11.0/$WINE_NAME.tar.xz"
WINE_SHA256="e6538a417dd2e7f738ad77addf74bfd9e45c9d970653674f93bde2df29055f2f"
# DirectX June 2010 redistributable, from Microsoft's download server.
REDIST_URL="https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe"
REDIST_SHA256="053f76dcbb28802e23341b6a787e3b0791c0fa5c8d4d011b1044172dbf89c73b"

WINE_DL="$HOME/.local/share/wine-builds/dl"
WINE_BUILD="$HOME/.local/share/wine-builds/$WINE_NAME"
WINEPREFIX="$HOME/.local/share/wineprefixes/aion-wine11.0"
CACHE="$HOME/.cache/aion-linux"
BIN_DIR="$HOME/.local/bin"
APPS_DIR="$HOME/.local/share/applications"
ICON="$HOME/.local/share/icons/hicolor/48x48/apps/aion.png"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

# Downloads $1 to $2 unless $2 already has SHA-256 $3. Partial downloads resume.
fetch() {
  local url="$1" dest="$2" sha="$3"
  if [[ -f "$dest" ]] && echo "$sha  $dest" | sha256sum -c --status 2>/dev/null; then
    return
  fi
  mkdir -p "$(dirname "$dest")"
  log "Downloading $(basename "$dest")"
  curl -fL --retry 3 --continue-at - -o "$dest.part" "$url"
  echo "$sha  $dest.part" | sha256sum -c --status || die "checksum mismatch for $(basename "$dest"); delete $dest.part and try again"
  mv "$dest.part" "$dest"
}

# Check everything we need before downloading anything.
for tool in curl sha256sum tar xz cabextract python3 getent; do
  command -v "$tool" >/dev/null || die "$tool is required (on Arch: sudo pacman -S $tool; on Debian/Ubuntu: sudo apt install $tool)"
done
[[ -f "$GAME_DIR/bin32/aion.bin" ]] || die "no Aion client in $GAME_DIR (expected bin32/aion.bin). Copy your Aion 1.9 client there, or set AION_DIR."

# 1. Wine
if [[ ! -x "$WINE_BUILD/bin/wine" ]]; then
  fetch "$WINE_URL" "$WINE_DL/$WINE_NAME.tar.xz" "$WINE_SHA256"
  log "Unpacking Wine"
  mkdir -p "$(dirname "$WINE_BUILD")"
  tar -xJf "$WINE_DL/$WINE_NAME.tar.xz" -C "$(dirname "$WINE_BUILD")"
fi
export PATH="$WINE_BUILD/bin:$PATH"

# 2. Prefix
if [[ ! -d "$WINEPREFIX" ]]; then
  log "Creating Wine prefix at $WINEPREFIX"
  mkdir -p "$WINEPREFIX"
  WINEPREFIX="$WINEPREFIX" WINEDLLOVERRIDES="mscoree,mshtml=d" WINEDEBUG=-all wineboot --init
  WINEPREFIX="$WINEPREFIX" wineserver -w
fi

# 3. D3DX9 and D3DCompiler, copied into the prefix's 32-bit system directory.
# Aion compiles its fog and water shaders with them at runtime; Wine's builtins
# render those wrong.
SYSWOW64="$WINEPREFIX/drive_c/windows/syswow64"
if [[ ! -f "$SYSWOW64/d3dx9_43.dll" || ! -f "$SYSWOW64/d3dcompiler_43.dll" ]]; then
  fetch "$REDIST_URL" "$CACHE/dl/directx_Jun2010_redist.exe" "$REDIST_SHA256"
  log "Extracting DirectX June 2010 redistributable"
  rm -rf "$CACHE/extract"
  mkdir -p "$CACHE/extract"
  cabextract -q -d "$CACHE/extract" "$CACHE/dl/directx_Jun2010_redist.exe"
  shopt -s nullglob nocaseglob
  for cab in "$CACHE"/extract/*d3dx9*_x86.cab "$CACHE"/extract/*d3dcompiler*_x86.cab; do
    cabextract -q -d "$CACHE/extract" "$cab"
  done
  shopt -u nullglob nocaseglob
  # The cabinets name D3DCompiler in capitals; the prefix uses lowercase.
  copied=0
  for dll in "$CACHE"/extract/*.dll; do
    name="$(basename "$dll" | tr 'A-Z' 'a-z')"
    case "$name" in
      d3dx9_2[4-9].dll|d3dx9_3[0-9].dll|d3dx9_4[0-3].dll|d3dcompiler_4[23].dll)
        cp "$dll" "$SYSWOW64/$name"
        copied=$((copied + 1))
        ;;
    esac
  done
  [[ -f "$SYSWOW64/d3dx9_43.dll" && -f "$SYSWOW64/d3dcompiler_43.dll" ]] \
    || die "D3DX9 and D3DCompiler were not found in the redistributable"
  log "Installed $copied D3DX9/D3DCompiler DLLs"
  rm -rf "$CACHE/extract"
fi

# 4. Launcher: the installed copy's default game folder is the one chosen here.
log "Installing the launcher to $BIN_DIR/aion"
mkdir -p "$BIN_DIR"
sed "s|\$HOME/Games/Aion|$GAME_DIR|" "$HERE/aion" > "$BIN_DIR/aion"
chmod +x "$BIN_DIR/aion"

# 5. App-menu entry and icon, taken from the game's own icon when it has one.
if [[ -f "$GAME_DIR/AionClient.ico" ]] && command -v magick >/dev/null; then
  mkdir -p "$(dirname "$ICON")"
  magick "$GAME_DIR/AionClient.ico[-1]" -resize 48x48 "$ICON" 2>/dev/null || true
fi
mkdir -p "$APPS_DIR"
cat > "$APPS_DIR/aion.desktop" <<EOF
[Desktop Entry]
Version=1.0
Name=Aion
Comment=Aion 1.9 on the AionGO server
Exec=$BIN_DIR/aion
Terminal=false
Type=Application
$([[ -f "$ICON" ]] && echo "Icon=$ICON")
Categories=Game;
StartupNotify=false
EOF
command -v update-desktop-database >/dev/null && update-desktop-database "$APPS_DIR" || true

log "Done. Start Aion from the app launcher, or run: aion"
