{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msgpack-c";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "msgpack";
    repo = "msgpack-c";
    tag = "c-${finalAttrs.version}";
    hash = "sha256-uMSOECctnUaThhB0vKKSvrjBmFzXDMIeusdiCrfOoI4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "MSGPACK_BUILD_EXAMPLES" false)
    (lib.cmakeBool "MSGPACK_BUILD_TESTS" false)
  ];

  meta = {
    description = "MessagePack implementation for C";
    homepage = "https://github.com/msgpack/msgpack-c";
    license = lib.licenses.boost;
  };
})
