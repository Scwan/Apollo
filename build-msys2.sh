#!/usr/bin/env bash
# Build the merged Apollo inside MSYS2 UCRT64. Run from a UCRT64 shell with the
# Windows PATH inherited (Node.js comes from the host), e.g. from PowerShell:
#   C:\Users\Epyc1\msys64\msys2_shell.cmd -defterm -no-start -ucrt64 -full-path -here -c "bash build-msys2.sh deps"
# Steps: deps | configure | build | all
set -euo pipefail
cd "$(dirname "$0")"
TOOLCHAIN="ucrt-x86_64"
STEP="${1:-all}"
LOG="build-msys2.log"

deps() {
  # The first -Syu may replace the msys runtime and ask for a shell restart;
  # each invocation of this script is a fresh process, so run it twice.
  pacman -Syuu --noconfirm --needed || true
  pacman -Syuu --noconfirm --needed
  local pkgs=(
    git
    "mingw-w64-${TOOLCHAIN}-boost"
    "mingw-w64-${TOOLCHAIN}-cmake"
    "mingw-w64-${TOOLCHAIN}-cppwinrt"
    "mingw-w64-${TOOLCHAIN}-curl-winssl"
    "mingw-w64-${TOOLCHAIN}-gcc"
    "mingw-w64-${TOOLCHAIN}-miniupnpc"
    "mingw-w64-${TOOLCHAIN}-nlohmann-json"
    "mingw-w64-${TOOLCHAIN}-onevpl"
    "mingw-w64-${TOOLCHAIN}-openssl"
    "mingw-w64-${TOOLCHAIN}-opus"
    "mingw-w64-${TOOLCHAIN}-toolchain"
    "mingw-w64-${TOOLCHAIN}-qt6-static"
    "mingw-w64-${TOOLCHAIN}-ninja"
    "mingw-w64-${TOOLCHAIN}-MinHook"
    "mingw-w64-${TOOLCHAIN}-python"        # glad's generator runs at build time
    "mingw-w64-${TOOLCHAIN}-python-jinja"  # and needs jinja2
  )
  pacman -S --noconfirm --needed "${pkgs[@]}"
  echo "=== deps done ==="
  gcc --version | head -1
  cmake --version | head -1
  node --version
}

configure() {
  mkdir -p build
  cmake -B build -G Ninja -S . \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DBUILD_WERROR=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_DOCS=OFF \
    -DSUNSHINE_ASSETS_DIR=assets \
    -DPython_EXECUTABLE=/ucrt64/bin/python.exe \
    -DGLAD_SKIP_PIP_INSTALL=ON \
    -DSUNSHINE_PUBLISHER_NAME="local-merge" \
    -DSUNSHINE_PUBLISHER_WEBSITE="https://github.com/ClassicOldSong/Apollo" \
    -DSUNSHINE_PUBLISHER_ISSUE_URL="https://github.com/ClassicOldSong/Apollo/issues"
  echo "=== configure done ==="
}

build() {
  ninja -C build
  echo "=== build done ==="
  ls -la build/sunshine.exe build/tools/sunshinesvc.exe 2>/dev/null || true
}

case "$STEP" in
  deps) deps ;;
  configure) configure ;;
  build) build ;;
  all) deps; configure; build ;;
  *) echo "unknown step $STEP" >&2; exit 2 ;;
esac
