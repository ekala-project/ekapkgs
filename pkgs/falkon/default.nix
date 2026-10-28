{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcoreaddons,
  kcrash,
  ki18n,
  kio,
  kwallet,
  purpose,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "falkon";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/falkon-${finalAttrs.version}.tar.xz";
    hash = "sha256-9Z7QtvsSruWj7TEOSJEEuBXjWhkni9foD5xe9ERhbwc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
    qt6.qtwebchannel
    qt6.qtwebengine
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebchannel
    qt6.qtwebengine
    extra-cmake-modules
    karchive
    kcoreaddons
    kcrash
    ki18n
    kio
    kwallet
    purpose
    python3Packages.pyside6
  ];

  meta = {
    description = "Cross-platform Qt-based web browser";
    homepage = "https://apps.kde.org/falkon/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "falkon";
  };
})
