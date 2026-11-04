{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  libqalculate,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-qt";
  version = "5.13.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NT1kRrN31+IjrkWGcLgFIawp73Senb88BTsgrYyEcuU=";
  };

  nativeBuildInputs = with qt6; [
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = with qt6; [
    libqalculate
    qtbase
    qtsvg
    qtwayland
  ];

  postPatch = ''
    substituteInPlace qalculate-qt.pro\
      --replace "LRELEASE" "${qt6.qttools}/bin/lrelease"
  '';

  meta = {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qalculate-qt";
    platforms = lib.platforms.unix;
  };
})
