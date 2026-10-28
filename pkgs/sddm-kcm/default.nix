{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kauth,
  kcmutils,
  kcoreaddons,
  ki18n,
  kio,
  knewstuff,
  kservice,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sddm-kcm";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/sddm-kcm-${finalAttrs.version}.tar.xz";
    hash = "sha256-t2QdFZlvWQ3yfY+CDf/HnYPOnk4ZqI8Dux2GUfqiWIc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    karchive
    kauth
    kcmutils
    kcoreaddons
    ki18n
    kio
    knewstuff
    kservice
  ];

  meta = {
    description = "Configuration module for SDDM";
    homepage = "https://invent.kde.org/plasma/sddm-kcm";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sddmthemeinstaller";
  };
})
