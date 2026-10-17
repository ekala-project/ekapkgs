{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcompletion,
  kconfig,
  ki18n,
  kwidgetsaddons,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktextwidgets";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/ktextwidgets-6.30.0.tar.xz";
    hash = "sha256-sGsRu3J7+cNXh5ex5A2q1fSOEEM+RWozfxxAtAgoecg=";
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
    qt6.qtspeech
    qt6.qttools
  ];

  propagatedBuildInputs = [
    kcompletion
    kconfig
    ki18n
    kwidgetsaddons
    sonnet
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE text editing widgets";
    homepage = "https://invent.kde.org/frameworks/ktextwidgets";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
