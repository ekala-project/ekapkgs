{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "libgeos";
    repo = "geos";
    tag = finalAttrs.version;
    hash = "sha256-lOf14Qva/bbbiywbSE7GbkDQftjY0RudTOaqjllnsj4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;unit-geom-Envelope"
  ];

  meta = {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = lib.licenses.lgpl21Only;
    mainProgram = "geosop";
    platforms = lib.platforms.all;
  };
})
