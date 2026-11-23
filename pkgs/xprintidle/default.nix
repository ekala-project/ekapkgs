{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxscrnsaver,
  libxext,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xprintidle";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "g0hl1n";
    repo = "xprintidle";
    tag = finalAttrs.version;
    sha256 = "sha256-I5lCIlQVvmZ5RM5ECXGbwtiWi9hXCQz2sil03AGlnlE=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libxscrnsaver
    libx11
    libxext
  ];

  meta = {
    homepage = "https://github.com/g0hl1n/xprintidle";
    description = "Utility that queries the X server for the user's idle time and prints it to stdout";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "xprintidle";
  };
})
