{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  karchive,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kguiaddons,
  kirigami,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ksvg";
  version = "6.30.0";

  src = fetchurl {
    url = "mirror://kde/stable/frameworks/6.30/ksvg-${finalAttrs.version}.tar.xz";
    hash = "sha256-e3q6TpuqiL+zA5d+E56KEFtc0kNEMCnudzlUMHtR65E=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    karchive
    kcolorscheme
    kconfig
    kcoreaddons
    kguiaddons
    kirigami
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Components for handling SVGs";
    homepage = "https://invent.kde.org/frameworks/ksvg";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
