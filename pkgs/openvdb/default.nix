{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  jemalloc,
  c-blosc,
  tbb,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "openvdb";
  version = "13.0.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    tag = "v${version}";
    hash = "sha256-+tfdZfir8pPZd5oehpHoYMtYmJWXgJYG5kB6JyuKOWE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    tbb
    jemalloc
    c-blosc
    zlib
  ];

  cmakeFlags = [
    "-DOPENVDB_CORE_STATIC=OFF"
    "-DOPENVDB_BUILD_NANOVDB=ON"
  ];

  meta = with lib; {
    description = "Open framework for voxel";
    mainProgram = "vdb_print";
    homepage = "https://www.openvdb.org";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
