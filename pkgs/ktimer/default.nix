{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  knotifications,
  kstatusnotifieritem,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktimer";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/ktimer-${finalAttrs.version}.tar.xz";
    hash = "sha256-PKMJyjm1O0GrGNQENGubrLm5nkuG75opWPNm8OsAMHY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    knotifications
    kstatusnotifieritem
    kwidgetsaddons
  ];

  meta = {
    description = "Little tool to execute programs after some time";
    homepage = "https://apps.kde.org/ktimer/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "ktimer";
  };
})
