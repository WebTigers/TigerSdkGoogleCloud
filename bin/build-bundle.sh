#!/usr/bin/env bash
# build-bundle.sh — vendor this module's cloud SDK and package it as an installable release zip.
# Self-configuring: reads the slug from module.json and the SDK package from composer.json, so this
# script is identical across every Tiger SDK provider module. Tracks upstream (latest of the package).
# Output: dist/<slug>-<sdk-version>.zip (+ .sha256); prints SLUG= and SDK_VERSION= on stdout.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; OUT="${OUT:-$ROOT/dist}"; cd "$ROOT"
for t in composer zip php; do command -v "$t" >/dev/null || { echo "!! '$t' required"; exit 1; }; done
SLUG=$(php -r 'echo json_decode(file_get_contents("module.json"),true)["slug"];')
PKG=$(php -r '$r=json_decode(file_get_contents("composer.json"),true)["require"];unset($r["php"]);echo array_key_first($r);')
echo "Module $SLUG vendoring $PKG (latest) ..."
rm -f composer.lock
COMPOSER_MEMORY_LIMIT=-1 composer update --no-dev --prefer-dist --optimize-autoloader --no-interaction --no-progress
VER=$(composer show "$PKG" 2>/dev/null | awk '/^versions/ {print $4}' | tr -d 'v*')
[ -n "$VER" ] || { echo "!! could not determine $PKG version"; exit 1; }
echo "Vendored $PKG $VER"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT; PKGDIR="$WORK/$SLUG"; mkdir -p "$PKGDIR"
if command -v rsync >/dev/null; then
  rsync -a --exclude='.git' --exclude='.github' --exclude='dist' --exclude='.idea' --exclude='composer.lock' ./ "$PKGDIR"/
else
  cp -a ./ "$PKGDIR"/ && rm -rf "$PKGDIR/.git" "$PKGDIR/.github" "$PKGDIR/dist" "$PKGDIR/.idea" "$PKGDIR/composer.lock"
fi
VER="$VER" php -r '$f=$argv[1];$m=json_decode(file_get_contents($f),true);$m["version"]=getenv("VER");file_put_contents($f,json_encode($m,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES)."\n");' "$PKGDIR/module.json"
mkdir -p "$OUT"; ZIP="$OUT/$SLUG-$VER.zip"; rm -f "$ZIP" "$ZIP.sha256"
( cd "$WORK" && zip -qr "$ZIP" "$SLUG" )
( cd "$OUT" && shasum -a 256 "$(basename "$ZIP")" > "$(basename "$ZIP").sha256" )
echo "Built $ZIP"; echo "SLUG=$SLUG"; echo "SDK_VERSION=$VER"
