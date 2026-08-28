{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  validatePkgConfig,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openjph";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "aous72";
    repo = "openjph";
    rev = finalAttrs.version;
    hash = "sha256-rMiWIu/D3zc80zX63jgorcY/JMJLfCBBXEAuDzzWc4I=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeBool "OJPH_ENABLE_TIFF_SUPPORT" false)
  ];

  strictDeps = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Open-source implementation of JPEG2000 Part-15 (or JPH or HTJ2K)";
    homepage = "https://openjph.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "openjph" ];
  };
})
