{
  stdenv,
  lib,
  fetchurl,
  perl,
  gmp,
  gf2x ? null,
  withGf2x ? (gf2x != null),
  tune ? false, # tune for current system; non reproducible and time consuming
}:

assert withGf2x -> gf2x != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "ntl";
  version = "11.6.0";

  src = fetchurl {
    url = "https://www.shoup.net/ntl/ntl-${finalAttrs.version}.tar.gz";
    hash = "sha256-vA75rOsHWmoGc6yNj0fV+EWMcv6AbkRo+9XT2v8FYYI=";
  };

  strictDeps = true;
  depsBuildBuild = [
    perl # needed for ./configure
  ];
  buildInputs = [
    gmp
  ];

  sourceRoot = "ntl-${finalAttrs.version}/src";

  enableParallelBuilding = true;

  dontAddPrefix = true; # DEF_PREFIX instead

  # Written in perl, does not support autoconf-style
  # --build=/--host= options:
  #   Error: unrecognized option: --build=x86_64-unknown-linux-gnu
  configurePlatforms = [ ];

  # reference: http://shoup.net/ntl/doc/tour-unix.html
  dontAddStaticConfigureFlags = true; # perl config doesn't understand it.
  configureFlags = [
    "DEF_PREFIX=$(out)"
    "NATIVE=off" # don't target code to current hardware (reproducibility, portability)
    "TUNE=${
      if tune then
        "auto"
      else if stdenv.hostPlatform.isx86 then
        "x86" # "chooses options that should be well suited for most x86 platforms"
      else
        "generic" # "chooses options that should be OK for most platforms"
    }"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "AR=${stdenv.cc.targetPrefix}ar"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
    "SHARED=on" # genereate a shared library
  ]
  ++ lib.optionals withGf2x [
    "NTL_GF2X_LIB=on"
    "GF2X_PREFIX=${gf2x}"
  ];

  enableParallelChecking = true;
  doCheck = true; # takes some time

  meta = {
    description = "Library for doing Number Theory";
    longDescription = ''
      NTL is a high-performance, portable C++ library providing data
      structures and algorithms for manipulating signed, arbitrary
      length integers, and for vectors, matrices, and polynomials over
      the integers and over finite fields.
    '';
    homepage = "http://www.shoup.net/ntl/";
    changelog = "https://www.shoup.net/ntl/doc/tour-changes.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
})
