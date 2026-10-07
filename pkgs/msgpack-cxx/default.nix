{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-cxx";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    tag = "cpp-${finalAttrs.version}";
    hash = "sha256-wT2zgv09RoVtkBVmm0NyRVoWSjqmIu/l36VeNMqdZOA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [
    boost
  ];

  cmakeEntries = {
    MSGPACK_BUILD_DOCS = false;
    MSGPACK_CXX20 = true;
  };

  cmakeFlags = lib.optional finalAttrs.finalPackage.doCheck "-DMSGPACK_BUILD_TESTS=ON";

  checkInputs = [
    zlib
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = {
    description = "MessagePack implementation for C++";
    homepage = "https://github.com/msgpack/msgpack-c";
    changelog = "https://github.com/msgpack/msgpack-c/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.boost;
  };
})
