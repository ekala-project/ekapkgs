{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "physfs";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "icculus";
    repo = "physfs";
    rev = "release-${version}";
    sha256 = "sha256-FhFIshX7G3uHEzvHGlDIrXa7Ux6ThQNzVssaENs+JMw=";
  };

  patches = [
    ./dont-set-cmake-skip-rpath.patch
  ];

  postPatch = ''
    sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' \
      -i CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [ zlib ];

  meta = {
    homepage = "https://icculus.org/physfs/";
    description = "Library to provide abstract access to various archives";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
  };
}
