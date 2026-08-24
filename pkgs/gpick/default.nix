{
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  ragel,
  pkg-config,
  wrapGAppsHook3,
  lua,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpick";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "thezbyg";
    repo = "gpick";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1I8eGYmjjMyeDnLG/2fdsQwK9dZowViNkt/tkKeAyFI=";
  };

  patches = [
    # gpick/cmake/Version.cmake
    ./dot-version.patch
  ];

  cmakeFlags = [
    "-DLUA_TYPE=C"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    boost
    ragel
    lua
  ];

  meta = {
    description = "Advanced color picker written in C++ using GTK+ toolkit";
    homepage = "https://www.gpick.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "gpick";
  };
})
