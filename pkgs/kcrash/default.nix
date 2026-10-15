{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kcrash";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kcrash-${finalAttrs.version}.tar.xz";
    hash = "sha256-sX+CQjCeFQIRnEix71BZo5ajBoWWqE+3n9722eLNT0k=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Support for application crash analysis and bug report from apps";
    homepage = "https://invent.kde.org/frameworks/kcrash";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
