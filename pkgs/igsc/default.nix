{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  metee,
  udev,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "igsc";
  version = "1.3.2";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "igsc";
    tag = "V${finalAttrs.version}";
    hash = "sha256-eqp4QIACQh4wGYHwb6CnDm7PGzKEdgdur+yo7deh0EI=";
  };

  buildInputs = [
    metee
    udev
  ];
  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    METEE_LIB_PATH = "${metee}/lib";
    METEE_HEADER_PATH = "${metee}/include";
  };
  meta = {
    mainProgram = "igsc";
    description = "Intel graphics system controller firmware update library";
    homepage = "https://github.com/intel/igsc";
    license = lib.licenses.asl20;
    changelog = "https://github.com/intel/igsc/releases/tag/V${finalAttrs.version}";
    platforms = lib.platforms.linux;
  };
})
