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
  version = "13.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    tag = "v${version}";
    hash = "sha256-SpXIwtO95DoFLt2Y0CcjLtOWIsjXC8zyt+tCQzMJ9Mc=";
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

  cmakeEntries = {
    OPENVDB_CORE_STATIC = false;
    OPENVDB_BUILD_NANOVDB = true;
  };

  meta = with lib; {
    description = "Open framework for voxel";
    mainProgram = "vdb_print";
    homepage = "https://www.openvdb.org";
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
