{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  dolphin,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kservice,
  ktexteditor,
  ktextwidgets,
  kxmlgui,
  solid,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dolphin-plugins";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/dolphin-plugins-${finalAttrs.version}.tar.xz";
    hash = "sha256-6akhUjyxffedsnyB1sMdCL4feL2Tfck5TZqv0so6EUM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    dolphin
    kconfig
    kcoreaddons
    ki18n
    kio
    kservice
    ktexteditor
    ktextwidgets
    kxmlgui
    solid
  ];

  meta = {
    description = "Plugins for Dolphin";
    homepage = "https://apps.kde.org/dolphin_plugins/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
