{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  attica,
  karchive,
  kconfig,
  kcoreaddons,
  ki18n,
  kirigami,
  kpackage,
  kwidgetsaddons,
  syndication,
  kcmutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knewstuff";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/knewstuff-6.30.0.tar.xz";
    hash = "sha256-hUCHaLXD9LC1HuahSuc/6iY/RRQE4mbihsVeDBfkQDc=";
  };

  patches = [ ./delay-resolving-knsrcdir.patch ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qtdeclarative
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
  ];

  propagatedBuildInputs = [
    attica
    karchive
    kconfig
    kcoreaddons
    ki18n
    kirigami
    kpackage
    kwidgetsaddons
    syndication
    kcmutils
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE framework for downloading and sharing additional application data";
    homepage = "https://invent.kde.org/frameworks/knewstuff";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    mainProgram = "knewstuff-dialog6";
  };
})
