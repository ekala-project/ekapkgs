{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  karchive,
  kauth,
  kcmutils,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  ki18n,
  kio,
  knewstuff,
  kservice,
  kwidgetsaddons,
  kxmlgui,
  plymouth,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plymouth-kcm";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plymouth-kcm-${finalAttrs.version}.tar.xz";
    hash = "sha256-znI9Z+a4zXG26zU+h8EPaYoJXqfUVb7nA9i6WeeT5X4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    karchive
    kauth
    kcmutils
    kconfig
    kconfigwidgets
    kcoreaddons
    ki18n
    kio
    knewstuff
    kservice
    kwidgetsaddons
    kxmlgui
    plymouth
  ];

  meta = {
    description = "KCM to manage the Plymouth (Boot) theme";
    homepage = "https://invent.kde.org/plasma/plymouth-kcm";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kplymouththemeinstaller";
  };
})
