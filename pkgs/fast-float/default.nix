{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fast-float";
  version = "8.4.0";

  src = fetchFromGitHub {
    owner = "fastfloat";
    repo = "fast_float";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5mnviVbaZfgLeAYp+W0O62brjzOCVTADFlXzSx+ofgs=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Fast and exact implementation of the C++ from_chars functions for number types";
    homepage = "https://github.com/fastfloat/fast_float";
    license = with lib.licenses; [
      asl20
      boost
      mit
    ];
    platforms = lib.platforms.all;
  };
})
