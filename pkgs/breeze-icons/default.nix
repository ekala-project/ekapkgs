{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  python3,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "breeze-icons";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/breeze-icons-${finalAttrs.version}.tar.xz";
    hash = "sha256-k4ZsGXkYOPyXV7MF4BDiO7OMtfIB5OzJbMjvXxFz6+Y=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    (python3.withPackages (ps: [ ps.lxml ]))
    libxml2
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    qt6.qtsvg
  ];

  dontWrapQtApps = true;

  # lots of icons, takes forever, does absolutely nothing
  dontStrip = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Breeze icon theme";
    homepage = "https://invent.kde.org/frameworks/breeze-icons";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
