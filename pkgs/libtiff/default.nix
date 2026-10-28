{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libjpeg,
  zlib,
  zstd,
  libdeflate,
  xz,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtiff";
  version = "4.7.2";

  src = fetchFromGitLab {
    owner = "libtiff";
    repo = "libtiff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-60Lpg5WRfWMzlOoOUA+C6KLlYIZ+3BjXidOVqv4M2GA=";
  };

  postPatch = ''
    mv VERSION VERSION.txt
    sed -i 's|"''${CMAKE_CURRENT_SOURCE_DIR}/VERSION"|"''${CMAKE_CURRENT_SOURCE_DIR}/VERSION.txt"|g' cmake/AutotoolsVersion.cmake
  '';

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  # Things listed in the pkg-config file need to be propagated
  propagatedBuildInputs = [
    libjpeg
    zlib
    zstd
    libdeflate
    xz
    # libwebp depends on us; this will cause infinite recursion otherwise
    (libwebp.override { tiffSupport = false; })
  ];

  cmakeEntries = {
    CMAKE_FIND_PACKAGE_PREFER_CONFIG = true;
  };

  meta = {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "https://libtiff.gitlab.io/libtiff";
    changelog = "https://libtiff.gitlab.io/libtiff/releases/v${finalAttrs.version}.html";
    license = lib.licenses.libtiff;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "libtiff-4" ];
  };
})
