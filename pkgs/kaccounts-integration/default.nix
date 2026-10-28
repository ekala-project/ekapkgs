{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  intltool,
  accounts-qt,
  kcmutils,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kio,
  kwallet,
  qcoro,
  signond,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaccounts-integration";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kaccounts-integration-${finalAttrs.version}.tar.xz";
    hash = "sha256-HYsR+wEVH0pEyuUXuyGxB0DBMIVrmatCzv1y1JRdYso=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  propagatedNativeBuildInputs = [ intltool ];

  buildInputs = [
    qt6.qtbase
    accounts-qt
    kcmutils
    kcoreaddons
    kdbusaddons
    ki18n
    kio
    kwallet
    qcoro
    signond
  ];

  meta = {
    description = "Online account management system and its Plasma integration components";
    homepage = "https://apps.kde.org/kaccounts-integration/";
    license = with lib.licenses; [
      gpl2Only
      gpl2Plus
      gpl3Only
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
})
