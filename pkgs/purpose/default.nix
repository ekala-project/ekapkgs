{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcmutils,
  kconfig,
  kcoreaddons,
  ki18n,
  kio,
  kirigami,
  kitemmodels,
  kservice,
  prison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "purpose";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/purpose-6.30.0.tar.xz";
    hash = "sha256-T9pk0jWSfjzCMEFtXJME9dPgQNwlU7d7LGm/VMbwSGI=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  propagatedBuildInputs = [
    kcmutils
    kconfig
    kcoreaddons
    ki18n
    kio
    kirigami
    kitemmodels
    kservice
    prison
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE framework for sharing and exporting content";
    homepage = "https://invent.kde.org/frameworks/purpose";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
