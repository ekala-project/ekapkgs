{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kfilemetadata,
  ki18n,
  kidletime,
  kio,
  solid,
  lmdb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "baloo";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/baloo-${finalAttrs.version}.tar.xz";
    hash = "sha256-pZ0zqRm/odFkyPOm+ZLGCe2vITGsX1LqTst39vvFO+E=";
  };

  # kde-systemd-start-condition is not part of baloo
  postPatch = ''
    substituteInPlace src/file/kde-baloo.service.in --replace-fail @KDE_INSTALL_FULL_BINDIR@/kde-systemd-start-condition /run/current-system/sw/bin/kde-systemd-start-condition
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    kfilemetadata
    ki18n
    kidletime
    kio
    solid
    lmdb
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Framework for searching and managing metadata";
    homepage = "https://invent.kde.org/frameworks/baloo";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
