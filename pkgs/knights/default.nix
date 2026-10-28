{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kio,
  kplotting,
  ksvg,
  ktextwidgets,
  kwallet,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knights";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/knights-${finalAttrs.version}.tar.xz";
    hash = "sha256-M5wSWaguDhK7ccpReNFFQkfQpLI/JkjA+rBSYfmK898=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    _7zz
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtspeech
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kio
    kplotting
    ksvg
    ktextwidgets
    kwallet
    kwidgetsaddons
    kxmlgui
    libkdegames
    kdePackages.libplasma
  ];

  meta = {
    description = "Chess board program";
    homepage = "https://apps.kde.org/knights/";
    license = with lib.licenses; [
      bsd3
      gpl2Only
      gpl2Plus
      gpl3Only
    ];
    platforms = lib.platforms.linux;
    mainProgram = "knights";
  };
})
