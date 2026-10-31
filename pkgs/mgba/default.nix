{
  lib,
  sdl2-compat,
  cmake,
  ninja,
  fetchFromGitHub,
  ffmpeg,
  libedit,
  elfutils,
  libepoxy,
  qt5,
  libzip,
  lua5_2_compat,
  minizip,
  pkg-config,
  stdenv,
  gtk3,
}:

let
  lua = lua5_2_compat;
  inherit (qt5)
    qtbase
    qtmultimedia
    qttools
    wrapQtAppsHook
    qtwayland
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mgba";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "mgba-emu";
    repo = "mgba";
    tag = finalAttrs.version;
    hash = "sha256-Za2o06odeisnrE3i7w54OeaPXHscZAaD1+EXii7bnuk=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    sdl2-compat
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
    wrapQtAppsHook
  ];

  buildInputs = [
    sdl2-compat
    ffmpeg
    libedit
    elfutils
    libepoxy
    libzip
    lua
    minizip
    qtbase
    qtmultimedia
    qttools
    qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ];

  strictDeps = true;

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    broken = true; # Discord_ClearPresence link error
    homepage = "https://mgba.io";
    description = "Modern GBA emulator with a focus on accuracy";
    license = lib.licenses.mpl20;
    mainProgram = "mgba";
    platforms = lib.platforms.linux;
  };
})
