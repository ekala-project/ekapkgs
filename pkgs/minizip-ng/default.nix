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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minizip-ng";
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

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DMZ_OPENSSL=ON"
    "-DMZ_PPMD=OFF"
    "-DMZ_LIBCOMP=OFF"
    "-DMZ_BUILD_TESTS=OFF"
    "-DMZ_BUILD_UNIT_TESTS=OFF"
    "-DMZ_COMPAT=OFF"
  ];

  strictDeps = true;

  meta = {
    description = "Fork of the popular zip manipulation library found in the zlib distribution";
    homepage = "https://github.com/zlib-ng/minizip-ng";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
