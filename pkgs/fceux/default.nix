{
  lib,
  stdenv,
  sdl2-compat,
  cmake,
  ninja,
  fetchFromGitHub,
  ffmpeg,
  libx11,
  libxdmcp,
  libxcb,
  lua5_1,
  minizip,
  pkg-config,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fceux";
  version = "2.6.6-unstable-2026-05-30";

  src = fetchFromGitHub {
    owner = "TASEmulators";
    repo = "fceux";
    rev = "a62b868e9247c4aafd66f597cdfa8d2609704087";
    hash = "sha256-nwlBRlIMUoLJO4T6Grle2AJYTpHt+as/cBMBegsL748=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    sdl2-compat
    ffmpeg
    libx11
    libxdmcp
    libxcb
    lua5_1
    minizip
    qt6.qttools
  ];

  cmakeEntries = {
    GLVND = true;
  };

  strictDeps = true;

  postInstall = ''
    substituteInPlace $out/share/applications/fceux.desktop \
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/usr/share/pixmaps/" ""
  '';

  meta = {
    homepage = "http://www.fceux.com";
    description = "Nintendo Entertainment System (NES) Emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fceux";
    platforms = lib.platforms.linux;
  };
})
