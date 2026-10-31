{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  hunspell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texworks";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-JygsOTryLXpFodwPGbPH3Baawl8k1Qkx2StZ1naInCc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    qt6.qt5compat
    qt6.qttools
    qt6.qtwayland
  ];

  cmakeFlags = [
    "-DQT_DEFAULT_MAJOR_VERSION=6"
    "-DWITH_LUA=OFF"
    "-DWITH_PYTHON=OFF"
  ];

  meta = {
    description = "Simple TeX front-end program inspired by TeXShop";
    homepage = "http://www.tug.org/texworks/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "texworks";
  };
})
