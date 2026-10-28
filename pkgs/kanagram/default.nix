{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kdoctools,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  ki18n,
  kio,
  knewstuff,
  kxmlgui,
  libkeduvocdocument,
  sonnet,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kanagram";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kanagram-${finalAttrs.version}.tar.xz";
    hash = "sha256-PT1FM8BmjAudG/IvHRDNFy1u9+C4P5bG3POh/BKfi9o=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtspeech
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    ki18n
    kio
    knewstuff
    kxmlgui
    libkeduvocdocument
    sonnet
  ];

  meta = {
    description = "Letter Order Game";
    homepage = "https://apps.kde.org/kanagram/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "kanagram";
  };
})
