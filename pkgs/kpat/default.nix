{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  shared-mime-info,
  kdoctools,
  kio,
  libkdegames,
  black-hole-solver,
  freecell-solver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpat";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kpat-${finalAttrs.version}.tar.xz";
    hash = "sha256-b0tp695WAtgI/oV+mJVoJVviw6m482yK2qlZ/lKbGhc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    _7zz
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    kio
    libkdegames
    black-hole-solver
    freecell-solver
  ];

  qtWrapperArgs = [ "--prefix XDG_DATA_DIRS : ${libkdegames}/share" ];

  meta = {
    description = "KPatience offers a selection of solitaire card games";
    homepage = "https://apps.kde.org/kpat/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kpat";
  };
})
