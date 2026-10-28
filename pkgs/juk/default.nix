{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  kjobwidgets,
  knotifications,
  kstatusnotifieritem,
  ktextwidgets,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  taglib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "juk";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/juk-${finalAttrs.version}.tar.xz";
    hash = "sha256-qWZQc5tRkubXZ+4Nq1WCV9LQpZVD5rKctOzrnZJO64o=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kjobwidgets
    knotifications
    kstatusnotifieritem
    ktextwidgets
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    taglib
  ];

  meta = {
    description = "Audio jukebox app, supporting collections of MP3, Ogg Vorbis and FLAC audio files";
    homepage = "https://apps.kde.org/juk/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "juk";
  };
})
