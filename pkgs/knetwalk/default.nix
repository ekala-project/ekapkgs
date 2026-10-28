{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  _7zz,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  libkdegames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "knetwalk";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/knetwalk-${finalAttrs.version}.tar.xz";
    hash = "sha256-v7+3IHImWBuVY5G0oZPrhKNE5lmIlCScE/MI5sAv6Xo=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    _7zz
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    libkdegames
  ];

  meta = {
    description = "KNetWalk: connect all the terminals to the server, in as few turns as possible";
    homepage = "https://apps.kde.org/knetwalk/";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "knetwalk";
  };
})
