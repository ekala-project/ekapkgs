{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kbookmarks,
  kcodecs,
  kcolorscheme,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  kfilemetadata,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  knotifications,
  kparts,
  ktextwidgets,
  kuserfeedback,
  kwindowsystem,
  kxmlgui,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolphin";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/dolphin-${finalAttrs.version}.tar.xz";
    hash = "sha256-i7G9/KsZ3WLXYlJw/GzDyBFFYA1nsFmfyf6J1xHMZzA=";
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
    kbookmarks
    kcodecs
    kcolorscheme
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kfilemetadata
    ki18n
    kiconthemes
    kio
    knewstuff
    knotifications
    kparts
    ktextwidgets
    kuserfeedback
    kwindowsystem
    kxmlgui
    solid
  ];

  meta = {
    description = "KDE file manager";
    homepage = "https://apps.kde.org/dolphin/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "dolphin";
  };
})
