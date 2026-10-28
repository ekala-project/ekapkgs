{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcodecs,
  kconfig,
  kcoreaddons,
  ki18n,
  kiconthemes,
  kio,
  ktextaddons,
  kwidgetsaddons,
  kxmlgui,
  sonnet,
  syntax-highlighting,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kpimtextedit";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kpimtextedit-${finalAttrs.version}.tar.xz";
    hash = "sha256-gHg3sxKrRqvI+UrBjn9psdpCuLPkN+5aYoWSwwIxiNQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    kcodecs
    kconfig
    kcoreaddons
    ki18n
    kiconthemes
    kio
    ktextaddons
    kwidgetsaddons
    kxmlgui
    sonnet
    syntax-highlighting
  ];

  meta = {
    description = "A textedit with PIM-specific features";
    homepage = "https://invent.kde.org/pim/kpimtextedit";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
