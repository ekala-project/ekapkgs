#!/usr/bin/env bash
# Build a package with timeout, report result
# Usage: build-pkg.sh <pkg-name>
# Exits 0 on success, 1 on failure, 2 on timeout

PKG="$1"
cd /home/jon/projects/ekapkgs

timeout 300 nix-build -A "$PKG" --no-out-link 2>&1 | tail -3
EXIT=${PIPESTATUS[0]}

if [ "$EXIT" -eq 0 ]; then
    echo "BUILD_OK: $PKG"
    exit 0
elif [ "$EXIT" -eq 124 ]; then
    echo "BUILD_TIMEOUT: $PKG"
    exit 2
else
    echo "BUILD_FAIL: $PKG"
    exit 1
fi
