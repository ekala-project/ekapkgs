{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcrash,
  kdbusaddons,
  kdoctools,
  kglobalaccel,
  ki18n,
  kiconthemes,
  kio,
  kitemviews,
  kwindowsystem,
  kxmlgui,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmenuedit";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kmenuedit-${finalAttrs.version}.tar.xz";
    hash = "sha256-LZgBt/iZiARkcsKzI4XYSKCpgJX7F41Y1uO1CQztm4s=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcrash
    kdbusaddons
    kglobalaccel
    ki18n
    kiconthemes
    kio
    kitemviews
    kwindowsystem
    kxmlgui
    sonnet
  ];

  meta = {
    description = "KDE menu editor";
    homepage = "https://invent.kde.org/plasma/kmenuedit";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmenuedit";
  };
})
