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
  version = "0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "lutok";
    rev = "lutok-${finalAttrs.version}";
    hash = "sha256-awAFxx9q8dZ6JO1/mShjhJnOPTLn1wCT4VrB4rlgWyg=";
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
