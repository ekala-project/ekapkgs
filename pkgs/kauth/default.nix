{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  kwindowsystem,
  polkit-qt-1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kauth";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/kauth-6.30.0.tar.xz";
    hash = "sha256-YLdeAqvCv7skfFhuOrlN737Ne04d24JgNYlR2E2eqMk=";
  };

  patches = [ ./fix-paths.patch ];

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
    kcoreaddons
    kwindowsystem
    polkit-qt-1
  ];

  dontWrapQtApps = true;

  meta = {
    description = "KDE authorization framework";
    homepage = "https://invent.kde.org/frameworks/kauth";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
