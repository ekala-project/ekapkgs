{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  python3,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ki18n";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/ki18n-${finalAttrs.version}.tar.xz";
    hash = "sha256-37/Ir4mzvGiBCwlL+HdG24fD7rNbdcrrGIJoHr7VY70=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    python3
  ];

  propagatedNativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Advanced internationalization framework";
    homepage = "https://invent.kde.org/frameworks/ki18n";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
