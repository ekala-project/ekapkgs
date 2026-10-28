{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kconfig,
  kguiaddons,
  kiconthemes,
  kirigami,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qqc2-breeze-style";
  version = "6.7.5";

  src = fetchurl {
    url = "mirror://kde/stable/plasma/${finalAttrs.version}/qqc2-breeze-style-${finalAttrs.version}.tar.xz";
    hash = "sha256-eI8GmMkEESzDO/b4+0RrLk/XIx04wJVcvDuqUNN10e4=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kcolorscheme
    kconfig
    kguiaddons
    kiconthemes
    kirigami
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Breeze inspired QQC2 Style";
    homepage = "https://invent.kde.org/plasma/qqc2-breeze-style";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
