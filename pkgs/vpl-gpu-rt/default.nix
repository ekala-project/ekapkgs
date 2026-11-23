{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libdrm,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpl-gpu-rt";
  version = "26.4.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vpl-gpu-rt";
    tag = "intel-onevpl-${finalAttrs.version}";
    hash = "sha256-7waFwJD2BPzstMDxS/XWdu25QTseqcA1NTxVtAchn/4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
  ];

  meta = {
    description = "oneAPI Video Processing Library Intel GPU implementation";
    homepage = "https://github.com/intel/vpl-gpu-rt";
    changelog = "https://github.com/intel/vpl-gpu-rt/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
