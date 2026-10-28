{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kguiaddons,
  ki18n,
  kiconthemes,
  knewstuff,
  ktexttemplate,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grantleetheme";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/grantleetheme-${finalAttrs.version}.tar.xz";
    hash = "sha256-8dsYLUIb7KdsMpytAWzR8ETUCHM4FBYV1kavhfxjRjQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kcolorscheme
    kguiaddons
    ki18n
    kiconthemes
    knewstuff
    ktexttemplate
    kxmlgui
  ];

  meta = {
    description = "KDE PIM Grantlee theme support";
    homepage = "https://invent.kde.org/pim/grantleetheme";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
