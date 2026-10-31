{
  lib,
  cmake,
  ninja,
  fetchFromGitHub,
  pkg-config,
  qt5,
  stdenv,
  unzip,
  zip,
}:

let
  inherit (qt5)
    qtbase
    qtscript
    qtsvg
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vym";
  version = "2.9.26";

  src = fetchFromGitHub {
    owner = "insilmaril";
    repo = "vym";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5cHhv9GDjJvSqGJ+7fI0xaWCiXw/0WP0Bem/ZRV8Y7M=";
  };

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace '/usr/bin/zip' '${lib.getExe zip}' \
      --replace '/usr/bin/unzip' '${lib.getExe unzip}'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtscript
    qtsvg
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        unzip
        zip
      ]
    }"
  ];

  strictDeps = true;

  meta = {
    homepage = "http://www.insilmaril.de/vym/";
    description = "Mind-mapping software";
    license = lib.licenses.gpl2Plus;
    mainProgram = "vym";
    platforms = lib.platforms.linux;
  };
})
