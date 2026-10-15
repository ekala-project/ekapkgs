{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  qt6,
  potrace,
  ffmpeg,
  libarchive,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glaxnimate";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "glaxnimate";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hHAe/xF6QDjiC2JqCUB1FngLsMSelMqEdHjXJwjTVjk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    potrace
    ffmpeg
    libarchive
  ];

  qtWrapperArgs = [
    "--prefix PYTHONPATH : ${
      python3Packages.makePythonPath [
        python3Packages.pillow
      ]
    }"
  ];

  meta = {
    description = "Simple vector animation program";
    homepage = "https://glaxnimate.org/";
    license = with lib.licenses; [
      bsd2
      cc-by-sa-40
      cc0
      gpl2Plus
      gpl3Plus
    ];
    mainProgram = "glaxnimate";
    platforms = lib.platforms.unix;
  };
})
