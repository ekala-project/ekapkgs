{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libuuid,
}:

stdenv.mkDerivation {
  pname = "crossguid";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "graeme-hill";
    repo = "crossguid";
    rev = "ca1bf4b810e2d188d04cb6286f957008ee1b7681";
    hash = "sha256-37tKPDo4lukl/aaDWWSQYfsBNEnDjE7t6OnEZjBhcvQ=";
  };

  patches = [
    # Fix the build against gcc-13:
    #   https://github.com/graeme-hill/crossguid/pull/67
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/graeme-hill/crossguid/commit/1eb9bea38c320b2b588635cffceaaa2a8d434780.patch";
      hash = "sha256-0qKZUeuNfc3gt+aFeaTt+IexO391GCdjS+9PVJmBKV4=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];
  buildInputs = lib.optional stdenv.hostPlatform.isLinux libuuid;

  meta = {
    description = "Lightweight cross platform C++ GUID/UUID library";
    license = lib.licenses.mit;
    homepage = "https://github.com/graeme-hill/crossguid";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
