{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kconfig";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kconfig-${finalAttrs.version}.tar.xz";
    hash = "sha256-Dpi6wyTNcWhJIC1LJGqUjjY9Z5Ko6wnHhBfN3pVZ9W4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Configuration system";
    homepage = "https://invent.kde.org/frameworks/kconfig";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
