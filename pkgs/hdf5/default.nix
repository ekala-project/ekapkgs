{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  removeReferencesTo,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "hdf5-cpp";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "HDFGroup";
    repo = "hdf5";
    rev = "hdf5_${version}";
    hash = "sha256-mJTax+VWAL3Amkq3Ij8fxazY2nfpMOTxYMUQlTvY/rg=";
  };

  patches = [
    (fetchpatch {
      name = "reproducible-build.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/hdf5/-/raw/721d33408db902ff738db18f1e977611d49b4ba8/hdf5-make-reproducible.patch";
      hash = "sha256-Z31dCsLjYpqjoGXooOXI81EPjPwyTK8890xCENTh8aM=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    removeReferencesTo
    cmake
    cmake.configurePhaseHook
  ];

  propagatedBuildInputs = [
    zlib
  ];

  cmakeFlags = [
    "-DHDF5_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "BUILD_STATIC_LIBS" false)
    (lib.cmakeBool "HDF5_BUILD_CPP_LIB" true)
    (lib.cmakeBool "HDF5_BUILD_FORTRAN" false)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_SUPPORT" false)
    (lib.cmakeBool "HDF5_ENABLE_PARALLEL" false)
    (lib.cmakeBool "HDF5_BUILD_JAVA" false)
    (lib.cmakeBool "HDF5_ENABLE_THREADSAFE" false)
    (lib.cmakeBool "HDF5_BUILD_HL_LIB" true)
    (lib.cmakeBool "HDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16" (
      with stdenv.hostPlatform; !(isDarwin && isx86_64)
    ))
  ];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
    moveToOutput 'bin/' "''${!outputBin}"
    moveToOutput 'bin/h5cc' "''${!outputDev}"
    moveToOutput 'bin/h5c++' "''${!outputDev}"
    moveToOutput 'bin/h5fc' "''${!outputDev}"
    moveToOutput 'bin/h5pcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlc++' "''${!outputDev}"

    pushd ''${!outputBin}/bin
    for file in *-shared; do
      mv "$file" "''${file%%-shared}"
    done
    popd
  '';

  passthru = {
    mpiSupport = false;
    mpi = null;
  };

  enableParallelBuilding = true;

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    homepage = "https://www.hdfgroup.org/HDF5/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
