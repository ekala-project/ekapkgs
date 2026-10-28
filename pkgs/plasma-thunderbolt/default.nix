{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  knotifications,
  kservice,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-thunderbolt";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-thunderbolt-${finalAttrs.version}.tar.xz";
    hash = "sha256-2BecNT+J3g7uaWGeMAud+bd4j85IZM+yzhJV8LxpFmQ=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kcmutils
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    knotifications
    kservice
  ];

  meta = {
    description = "Plasma integration for controlling Thunderbolt devices";
    homepage = "https://invent.kde.org/plasma/plasma-thunderbolt";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
