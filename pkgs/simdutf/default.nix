{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libiconv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdutf";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PKL495sfkRKjHfN4RroW1dwudJV2JWN7ogB8hyDxj5Y=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  buildInputs = [
    libiconv
  ];

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Unicode routines validation and transcoding at billions of characters per second";
    homepage = "https://github.com/simdutf/simdutf";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    pkgConfigModules = [ "simdutf" ];
    platforms = lib.platforms.all;
  };
})
