{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kbookmarks,
  kconfig,
  kcoreaddons,
  kdoctools,
  ki18n,
  kio,
  kservice,
  ktexttemplate,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  xapian,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "khelpcenter";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/khelpcenter-${finalAttrs.version}.tar.xz";
    hash = "sha256-O+NBe4Mm7kmgLoOmGHaY13cgf5fS7YlzszdVJHmOtEw=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    karchive
    kbookmarks
    kconfig
    kcoreaddons
    ki18n
    kio
    kservice
    ktexttemplate
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    xapian
    python3
  ];

  meta = {
    description = "Software documentation viewer";
    homepage = "https://invent.kde.org/system/khelpcenter";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "khelpcenter";
  };
})
