{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  bzip2,
  xz,
  zstd,
  openssl,
  enableCompat ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizip-ng" + lib.optionalString enableCompat "-compat";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "zlib-ng";
    repo = "minizip-ng";
    rev = finalAttrs.version;
    hash = "sha256-yPDH9Far8I+tpNeIoXt6w2Aj1/LEYFjwaHyLZMavCCA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    zlib
    bzip2
    xz
    zstd
    openssl
  ];

  cmakeEntries = {
    BUILD_SHARED_LIBS = true;
    MZ_OPENSSL = true;
    MZ_PPMD = false;
    MZ_LIBCOMP = false;
    MZ_BUILD_TESTS = false;
    MZ_BUILD_UNIT_TESTS = false;
    MZ_COMPAT = enableCompat;
  };

  strictDeps = true;

  meta = {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
