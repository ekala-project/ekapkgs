{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kconfig,
  kconfigwidgets,
  kglobalaccel,
  ki18n,
  kiconthemes,
  kitemviews,
  ktextwidgets,
  kwidgetsaddons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kxmlgui";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kxmlgui-6.30.0.tar.xz";
    hash = "sha256-EPuKD3uHQkj/YNmo7k4fBqDvzwGw0012Nd//huhIw1I=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    kconfig
    kconfigwidgets
    kglobalaccel
    ki18n
    kiconthemes
    kitemviews
    ktextwidgets
    kwidgetsaddons
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE framework for building user interfaces from XML";
    homepage = "https://invent.kde.org/frameworks/kxmlgui";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
