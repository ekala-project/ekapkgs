{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  makeFontsConf,
  pkg-config,
  pugixml,
  wayland,
  libGL,
  libffi,
  buildPackages,
  docSupport ? true,
  doxygen,
  graphviz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "waylandpp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "NilsBrause";
    repo = "waylandpp";
    tag = finalAttrs.version;
    hash = "sha256-vKYKUXq5lmjQcZ0rD+b2O7N1iCVnpkpKd8Z/RTI083g=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" (placeholder "dev"))
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    (lib.cmakeFeature "WAYLAND_SCANNERPP" "${buildPackages.waylandpp}/bin/wayland-scanner++")
  ];

  env = lib.optionalAttrs docSupport {
    FONTCONFIG_FILE = makeFontsConf {
      fontDirectories = [ ];
    };
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ]
  ++ lib.optionals docSupport [
    doxygen
    graphviz
  ];

  buildInputs = [
    pugixml
    wayland
    libGL
    libffi
  ];

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals docSupport [
    "doc"
    "devman"
  ];

  preBuild = ''
    export XDG_CACHE_HOME="$(mktemp -d)"
  '';

  meta = {
    description = "Wayland C++ binding";
    mainProgram = "wayland-scanner++";
    homepage = "https://github.com/NilsBrause/waylandpp/";
    license = with lib.licenses; [
      bsd2
      hpnd
    ];
    platforms = lib.platforms.linux;
  };
})
