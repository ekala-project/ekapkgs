{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kbookmarks,
  kcodecs,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  kparts,
  kwidgetsaddons,
  kwindowsystem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keditbookmarks";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/keditbookmarks-${finalAttrs.version}.tar.xz";
    hash = "sha256-VMNMJSlnZ9fng1luTeMzyD/SofPKBK9wqh+5h7134xk=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kbookmarks
    kcodecs
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kio
    kparts
    kwidgetsaddons
    kwindowsystem
  ];

  meta = {
    description = "Bookmarks editor";
    homepage = "https://apps.kde.org/keditbookmarks/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
