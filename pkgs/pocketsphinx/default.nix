{
  lib,
  stdenv,
  cmake,
  doxygen,
  fetchFromGitHub,
  graphviz,
  gstreamer,
  perl,
  pkg-config,
  testers,
  sox,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pocketsphinx";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "cmusphinx";
    repo = "pocketsphinx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bB/k1KRrdP52MN5iZr2Q2MGWh0JOCsqJxccUyVu2Va0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    graphviz
    pkg-config
  ];

  buildInputs = [ gstreamer ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
    BUILD_GSTREAMER = true;
    CMAKE_INSTALL_DATADIR = "${placeholder "data"}/share";
  };

  outputs = [
    "out"
    "data"
    "dev"
    "lib"
    "man"
  ];

  nativeCheckInputs = [
    perl
    sox
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Small speech recognizer";
    homepage = "https://github.com/cmusphinx/pocketsphinx";
    changelog = "https://github.com/cmusphinx/pocketsphinx/blob/v${finalAttrs.version}/NEWS";
    license =
      with lib.licenses;
      AND [
        bsd2
        bsd3
        mit
      ];
    pkgConfigModules = [ "pocketsphinx" ];
    mainProgram = "pocketsphinx";
  };
})
