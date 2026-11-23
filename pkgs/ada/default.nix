{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gbenchmark,
  gtest,
  simdjson,
  simdutf,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ada";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "ada-url";
    repo = "ada";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rwn8bKG6PEVUMCj0Oz6/BGFRH25IoyGf1iMWvGXm4r4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    validatePkgConfig
  ];

  buildInputs = [ simdutf ];

  doCheck = true;

  checkInputs = [
    simdjson
    gtest
    gbenchmark
  ];

  cmakeEntries = {
    ADA_TOOLS = false;
    ADA_USE_SIMDUTF = true;
    FETCHCONTENT_FULLY_DISCONNECTED = true;
    CPM_USE_LOCAL_PACKAGES = true;
  };

  cmakeFlags = [
    (lib.cmakeBool "ADA_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  passthru = {

    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "WHATWG-compliant and fast URL parser written in modern C";
    homepage = "https://github.com/ada-url/ada";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.all;
    pkgConfigModules = [ "ada" ];
  };
})
