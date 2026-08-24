{
  cmake,
  stdenv,
  lib,
  fetchFromGitHub,
  pugixml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblsl";
  version = "1.17.7";

  src = fetchFromGitHub {
    owner = "sccn";
    repo = "liblsl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-u7MfZcpe5IoDVzbe30/+DLsvBhetJA163KiBXWoSVME=";
  };

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ];

  buildInputs = [ pugixml ];

  cmakeFlags = [
    "-DLSL_UNIXFOLDERS=ON"
    "-DLSL_FETCH_PUGIXML=OFF"
  ];

  meta = {
    description = "C++ lsl library for multi-modal time-synched data transmission over the local network";
    homepage = "https://github.com/sccn/liblsl";
    changelog = "https://github.com/sccn/liblsl/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
