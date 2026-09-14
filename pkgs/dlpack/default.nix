{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dlpack";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "dmlc";
    repo = "dlpack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kIHBgTYaHEmweRBFtRl1pXhOyQ5TEwU8dLUssTMEnpc=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Open in-memory tensor structure for sharing tensors among frameworks";
    homepage = "https://github.com/dmlc/dlpack";
    license = lib.licenses.asl20;
  };
})
