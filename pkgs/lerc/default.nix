{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lerc";
  version = "4.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "esri";
    repo = "lerc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ysD+0B5yMOdNOKe9MS2T8o0KgqygdxLYiLMr8XeG4JE=";
  };

  # The upstream patch use-cmake-install-full-dir.patch from core-pkgs no
  # longer applies — v4.1.1 already uses @LERC_PC_INCLUDEDIR@ / @LERC_PC_LIBDIR@
  # in Lerc.pc.in, which CMake sets correctly.

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "C++ library for Limited Error Raster Compression";
    homepage = "https://github.com/esri/lerc";
    license = lib.licenses.asl20;
    maintainers = [ ];
    pkgConfigModules = [ "Lerc" ];
  };
})
