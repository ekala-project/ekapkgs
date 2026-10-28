{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcrash,
  kdoctools,
  ki18n,
  kio,
  kxmlgui,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmag";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kmag-${finalAttrs.version}.tar.xz";
    hash = "sha256-H2KvP5afl9Ms3a+0bgkws0aqIWiuz/nL3WdEf2t7CII=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kcrash
    ki18n
    kio
    kxmlgui
    kdePackages.libqaccessibilityclient
  ];

  meta = {
    description = "Screen magnifier";
    homepage = "https://apps.kde.org/kmag/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kmag";
  };
})
