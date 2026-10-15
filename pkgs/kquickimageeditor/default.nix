{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  kirigami,
  opencv4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kquickimageeditor";
  version = "0.6.1";

  src = fetchurl {
    url = "mirror://kde/stable/kquickimageeditor/kquickimageeditor-${finalAttrs.version}.tar.xz";
    hash = "sha256-uGiAC7m7gU7jbJ1pa+nM7Joiq2+XXXieJIt1+9G6mfo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kirigami
    (opencv4.override {
      enableCuda = false;
      enabledModules = [
        "core"
        "imgproc"
      ];
      runAccuracyTests = false;
    })
  ];

  dontWrapQtApps = true;

  cmakeEntries = {
    BUILD_TESTING = false;
  };

  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
