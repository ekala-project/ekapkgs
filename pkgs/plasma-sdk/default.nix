{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcmutils,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  ki18n,
  kiconthemes,
  kio,
  kitemmodels,
  kpackage,
  kparts,
  ksvg,
  ktexteditor,
  ktextwidgets,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  libplasma ? null, # TODO: not yet in ekapkgs
  plasma5support ? null, # TODO: not yet in ekapkgs
  solid,
  sonnet,
  syntax-highlighting,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-sdk";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/plasma-sdk-${finalAttrs.version}.tar.xz";
    hash = "sha256-stbPs22+akCPIsndq9rmI+t6oN4VSFgn8wpyWmRebg8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    karchive
    kcmutils
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    kitemmodels
    kpackage
    kparts
    ksvg
    ktexteditor
    ktextwidgets
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    solid
    sonnet
    syntax-highlighting
  ]
  ++ lib.optional (libplasma != null) libplasma
  ++ lib.optional (plasma5support != null) plasma5support;

  meta = {
    description = "Applications useful for Plasma development";
    homepage = "https://invent.kde.org/plasma/plasma-sdk";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
