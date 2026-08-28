{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libebml,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmatroska";
  version = "1.7.1";

  outputs = [
    "dev"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libmatroska";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-hfu3Q1lIyMlWFWUM2Pu70Hie0rlQmua7Kq8kSIWnfHE=";
  };

  patches = [
    (fetchpatch {
      name = "libmatroska-fix-cmake-4.patch";
      url = "https://github.com/Matroska-Org/libmatroska/commit/dc80e194e93e6f0e25c8ad3e015d83aca2a99e10.patch";
      hash = "sha256-2dKRJ6z5rOrLJ5agvXQ6k8TPi5rTMA3H1wCO2F5tBbc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [ libebml ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=YES" ];

  meta = {
    description = "Library to parse Matroska files";
    homepage = "https://matroska.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
})
