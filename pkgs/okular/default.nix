{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qt6,
  karchive,
  kbookmarks,
  kcolorscheme,
  ki18n,
  kio,
  kparts,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  purpose,
  threadweaver,
  poppler,
  libtiff,
  libspectre,
  libzip,
  djvulibre,
  ebook_tools,
  discount,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "okular";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/okular-${finalAttrs.version}.tar.xz";
    hash = "sha256-+bOavLfGw6zl16z2afp+1HzzqnuTKotqviq72AdfyfU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtspeech
    qt6.qtsvg
    qt6.qtdeclarative
    karchive
    kbookmarks
    kcolorscheme
    ki18n
    kio
    kparts
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    purpose
    threadweaver
    poppler
    libtiff
    libspectre
    libzip
    djvulibre
    ebook_tools
    discount
  ];

  meta = {
    description = "KDE universal document viewer";
    homepage = "https://apps.kde.org/okular/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "okular";
  };
})
