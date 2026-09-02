{
  cairo,
  cmake,
  fetchFromGitHub,
  libuv,
  libxdmcp,
  libpthread-stubs,
  libxcb,
  libxcb-image,
  libxcb-wm,
  pcre,
  pkg-config,
  python3,
  python3Packages,
  lib,
  stdenv,
  xcb-proto,
  xcbutil,
  xcb-util-cursor,
  xcbutilxrm,
  removeReferencesTo,
  alsa-lib,
  libnl,
  jsoncpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polybar";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "polybar";
    repo = "polybar";
    rev = finalAttrs.version;
    hash = "sha256-5PYKl6Hi4EYEmUBwkV0rLiwxNqIyR5jwm495YnNs0gI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3Packages.sphinx
    removeReferencesTo
  ];

  buildInputs = [
    cairo
    libuv
    libxdmcp
    libpthread-stubs
    libxcb
    libxcb-image
    libxcb-wm
    pcre
    python3
    xcb-proto
    xcbutil
    xcb-util-cursor
    xcbutilxrm
    alsa-lib
    libnl
    jsoncpp
  ];

  patches = [ ./remove-hardcoded-etc.diff ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "/etc" $out
    substituteAllInPlace src/utils/file.cpp
  '';

  postInstall = ''
    remove-references-to -t ${stdenv.cc} $out/bin/polybar
  '';

  meta = {
    homepage = "https://polybar.github.io/";
    description = "Fast and easy-to-use tool for creating status bars";
    license = lib.licenses.mit;
    mainProgram = "polybar";
    platforms = lib.platforms.linux;
  };
})
