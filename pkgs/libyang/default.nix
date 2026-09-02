{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pcre2,
  xxhash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libyang";
  version = "5.8.6";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libyang";
    rev = "v${finalAttrs.version}";
    hash = "sha256-t2DYY0xMbGuOKllaJeyT+pJJ5wTVtYXHrDtwMmZxjBw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    xxhash
  ];

  propagatedBuildInputs = [
    pcre2
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = {
    description = "YANG data modelling language parser and toolkit";
    homepage = "https://github.com/CESNET/libyang";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
