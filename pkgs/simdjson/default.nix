{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdjson";
  version = "4.6.8";

  src = fetchFromGitHub {
    owner = "simdjson";
    repo = "simdjson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZMYYjwyeqqlklwY4UWBgT5sJ0Ojkg38Xcxg6CO461Ec=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "SIMDJSON_DEVELOPER_MODE" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    homepage = "https://simdjson.org/";
    description = "Parsing gigabytes of JSON per second";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
