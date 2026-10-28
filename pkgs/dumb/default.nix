{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumb";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "kode54";
    repo = "dumb";
    tag = "${finalAttrs.version}";
    hash = "sha256-Jl7N1a0hk55l22sQN/RW6EVWZbpiRA8ypZ40ElY22LI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    BUILD_EXAMPLES = false;
    BUILD_ALLEGRO4 = false;
  };

  meta = {
    description = "IT, XM, S3M and MOD player library";
    homepage = "https://github.com/kode54/dumb";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
