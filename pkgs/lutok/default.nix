{
  lib,
  stdenv,
  fetchFromGitHub,
  atf,
  autoreconfHook,
  lua,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lutok";
  version = "0.6.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "lutok";
    rev = "lutok-${finalAttrs.version}";
    hash = "sha256-g20I/vbSo71ECuwXW05mKIHEXnbMKdVxAqrPHS7UaMI=";
  };

  strictDeps = true;

  propagatedBuildInputs = [ lua ];

  nativeBuildInputs = [
    atf
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "CXXFLAGS=-std=c++11"
  ];

  doCheck = false;

  __structuredAttrs = true;

  meta = {
    description = "Lightweight C++ API for Lua";
    homepage = "https://github.com/freebsd/lutok/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
