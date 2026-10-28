{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kcolorscheme,
  kconfig,
  kcoreaddons,
  kcrash,
  kglobalaccel,
  kguiaddons,
  ki18n,
  kiconthemes,
  kirigami,
  kitemmodels,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kirigami-addons";
  version = "1.15.0";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-addons/kirigami-addons-${finalAttrs.version}.tar.xz";
    hash = "sha256-gkNsdYnNqy4u5rLn1as77foEn6fe1UmMAakKBLnNu7M=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtmultimedia
    kcolorscheme
    kconfig
    kcoreaddons
    kcrash
    kglobalaccel
    kguiaddons
    ki18n
    kiconthemes
    kirigami
    kitemmodels
  ];

  meta = {
    description = "Add-ons for the Kirigami framework";
    homepage = "https://invent.kde.org/libraries/kirigami-addons";
    license = with lib.licenses; [
      bsd2
      cc-by-sa-40
      cc0
      gpl2Plus
      lgpl2Only
      lgpl2Plus
      lgpl21Only
      lgpl21Plus
      lgpl3Only
    ];
    platforms = lib.platforms.linux;
  };
})
