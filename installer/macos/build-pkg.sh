#!/bin/bash
# Builds dist/TapPanZeit-<version>-macOS.pkg, which installs the VST3 and AU
# into /Library/Audio/Plug-Ins/{VST3,Components}. Run after a Release build.
#
#   installer/macos/build-pkg.sh <version> [artefacts dir]
set -euo pipefail

VERSION="${1:?usage: build-pkg.sh <version> [artefacts dir]}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
ARTEFACTS="${2:-$ROOT/build/TapPanZeit_artefacts/Release}"
OUT="$ROOT/dist/TapPanZeit-$VERSION-macOS.pkg"
ID=us.steinkamp.TapPanZeit

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$WORK/pkgs" "$ROOT/dist"

# component_pkg <bundle> <install dir> <pkg id> [scripts dir]
component_pkg() {
  local bundle="$1" dest="$2" pkgid="$3" scripts="${4:-}"
  local name root plist
  name="$(basename "$bundle")"
  root="$WORK/root-$name"
  plist="$WORK/$name.plist"

  mkdir -p "$root"
  ditto "$bundle" "$root/$name"

  # Without this, Installer "relocates" the update to wherever it finds an
  # existing copy of the bundle (e.g. a build folder) instead of $dest.
  pkgbuild --analyze --root "$root" "$plist" >/dev/null
  plutil -replace 0.BundleIsRelocatable -bool NO "$plist"

  pkgbuild --root "$root" --component-plist "$plist" --identifier "$pkgid" --version "$VERSION" \
    --install-location "$dest" ${scripts:+--scripts "$scripts"} "$WORK/pkgs/$pkgid.pkg" >/dev/null
}

component_pkg "$ARTEFACTS/VST3/TapPanZeit.vst3" /Library/Audio/Plug-Ins/VST3 "$ID.vst3"
component_pkg "$ARTEFACTS/AU/TapPanZeit.component" /Library/Audio/Plug-Ins/Components "$ID.au" "$HERE/scripts-au"

sed "s/__VERSION__/$VERSION/g" "$HERE/distribution.xml" >"$WORK/distribution.xml"
productbuild --distribution "$WORK/distribution.xml" --package-path "$WORK/pkgs" \
  --resources "$HERE/resources" "$OUT" >/dev/null

echo "$OUT"
