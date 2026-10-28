{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kauth,
  kcmutils,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kdeclarative ? null, # TODO: not yet in ekapkgs
  ki18n,
  kio,
  knotifications,
  kservice,
  kwidgetsaddons,
  kwindowsystem,
  solid,
  smartmontools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-disks";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-disks-${finalAttrs.version}.tar.xz";
    hash = "sha256-NBJc0x5VnU0P70m7M6b/wYAxEqF0la4b+89ei+2kZMQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kauth
    kcmutils
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    knotifications
    kservice
    kwidgetsaddons
    kwindowsystem
    solid
    smartmontools
  ]
  ++ lib.optional (kdeclarative != null) kdeclarative;

  meta = {
    description = "Monitors S.M.A.R.T. capable devices for imminent failure";
    homepage = "https://invent.kde.org/plasma/plasma-disks";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
