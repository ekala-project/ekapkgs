{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  shared-mime-info,
  analitza,
  karchive,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  knewstuff,
  kparts,
  ktexteditor,
  ktextwidgets,
  kxmlgui,
  syntax-highlighting,
  libqalculate,
  libspectre,
  luajit,
  poppler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cantor";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/cantor-${finalAttrs.version}.tar.xz";
    hash = "sha256-u1YzYXXpCHApDnQy81BJrFBWOk27uRAu/naWr4B7Q3c=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
    pkg-config
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    qt6.qtwebengine
    analitza
    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    ki18n
    kiconthemes
    kio
    knewstuff
    kparts
    ktexteditor
    ktextwidgets
    kxmlgui
    syntax-highlighting
    libqalculate
    libspectre
    luajit
    poppler
    # FIXME: can't find R, Julia - if anyone needs this, feel free to investigate
  ];

  meta = {
    description = "Front end to powerful mathematics and statistics packages";
    homepage = "https://apps.kde.org/cantor/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "cantor";
  };
})
