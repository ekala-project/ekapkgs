{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kxmlgui,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktextaddons";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${finalAttrs.version}.tar.xz";
    hash = "sha256-JrePq4LOdvoZ2NKkd1djHSHcrdtoFEQrbdKFPmXNWoE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtspeech
    qt6.qttools
    kxmlgui
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Various text handling addons";
    homepage = "https://invent.kde.org/libraries/ktextaddons";
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Plus
      lgpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
