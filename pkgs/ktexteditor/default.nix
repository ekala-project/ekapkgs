{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kauth,
  kcolorscheme,
  kconfig,
  kguiaddons,
  ki18n,
  kio,
  kjobwidgets,
  kparts,
  kxmlgui,
  sonnet,
  syntax-highlighting,
  editorconfig-core-c,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktexteditor";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/ktexteditor-6.30.0.tar.xz";
    hash = "sha256-2Q8k4zp6oOahea8lPf3soJd5kq22K/G2960RU3q24+c=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtspeech
    editorconfig-core-c
  ];

  propagatedBuildInputs = [
    karchive
    kauth
    kcolorscheme
    kconfig
    kguiaddons
    ki18n
    kio
    kjobwidgets
    kparts
    kxmlgui
    sonnet
    syntax-highlighting
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE advanced text editing component";
    homepage = "https://invent.kde.org/frameworks/ktexteditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
