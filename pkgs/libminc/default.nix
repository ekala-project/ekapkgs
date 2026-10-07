{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  netcdf,
  nifticlib,
  hdf5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libminc";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = "libminc";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-IQS8JDkZwLR73I5GpWKRT07zj7Ek2tdZ2TOjy02OjaQ=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake.configurePhaseHook
    cmake
  ];
  buildInputs = [
    zlib
    nifticlib
  ];
  propagatedBuildInputs = [
    netcdf
    hdf5
  ];

  cmakeEntries = {
    LIBMINC_MINC1_SUPPORT = true;
    LIBMINC_BUILD_SHARED_LIBS = true;
    LIBMINC_USE_NIFTI = true;
    LIBMINC_USE_SYSTEM_NIFTI = true;
  };

  doCheck = !stdenv.hostPlatform.isDarwin;
  # -j1: see https://github.com/BIC-MNI/libminc/issues/110
  checkPhase = ''
    ctest -j1 --output-on-failure
  '';

  meta = {
    homepage = "https://github.com/BIC-MNI/libminc";
    description = "Medical imaging library based on HDF5";
    platforms = lib.platforms.unix;
    license = lib.licenses.free;
  };
})
