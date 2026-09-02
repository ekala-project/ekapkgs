{
  lib,
  pkg-config,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  zlib,
}:

clangStdenv.mkDerivation rec {
  pname = "capnproto";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "capnproto";
    rev = "v${version}";
    hash = "sha256-CuhKOJwU+QG25lRR8F7ina+DV45ZlLzg/UJ2swf2tZ0=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  propagatedBuildInputs = [
    openssl
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "WITH_FIBERS" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "None")
  ];

  env = {
    CXXFLAGS = "-std=c++20";
  };

  meta = {
    homepage = "https://capnproto.org/";
    description = "Cap'n Proto cerealization protocol";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
