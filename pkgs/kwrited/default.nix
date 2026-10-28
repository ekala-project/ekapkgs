{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  knotifications,
  kpty,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwrited";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/kwrited-${finalAttrs.version}.tar.xz";
    hash = "sha256-+KqQVzTQzN55aITPywazYITkQfsZnqWqsrySz6TAUG0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    kcoreaddons
    kdbusaddons
    ki18n
    knotifications
    kpty
  ];

  meta = {
    description = "KDE daemon listening for wall and write messages";
    homepage = "https://invent.kde.org/plasma/kwrited";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kwrited";
  };
})
