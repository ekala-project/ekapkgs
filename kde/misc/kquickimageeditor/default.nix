{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  kirigami,
  qtbase,
  qtdeclarative,
  opencv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kquickimageeditor";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "kquickimageeditor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MluY8nkMtg1uLAStDZFDxyJoeDrcp3smZ4U5IG5sXMk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
  ];

  buildInputs = [
    kirigami
    qtbase
    qtdeclarative
    opencv
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Set of QtQuick components providing basic image editing capabilities";
    homepage = "https://invent.kde.org/libraries/kquickimageeditor";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
})
