{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  gfortran,
  blas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "superlu";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "xiaoyeli";
    repo = "superlu";
    tag = "v${finalAttrs.version}";
    postFetch = "rm $out/SRC/mc64ad.* $out/DOC/*.pdf";
    hash = "sha256-MiQPhYIGZbvmtpIojrNzTG4Xao7lc4Ks/FtxlfdAKmQ=";
  };

  patches = [
    (fetchurl {
      url = "https://salsa.debian.org/science-team/superlu/-/raw/fae141179928d1cc5a8e381503e8b1264d297c3d/debian/patches/mc64ad-stub.patch";
      hash = "sha256-QUaNUDaRghTqr6jk1TE6a7CdXABqu7xAkYZDhL/lZBQ=";
    })
  ];

  postPatch = lib.optionalString stdenv.cc.isClang ''
    echo 'target_compile_options(matgen PRIVATE -fno-vectorize)' >> TESTING/MATGEN/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    gfortran
  ];

  propagatedBuildInputs = [ blas ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "enable_fortran" true)
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  doCheck = true;

  meta = {
    homepage = "https://portal.nersc.gov/project/sparse/superlu/";
    license = [
      lib.licenses.bsd3Lbnl
      lib.licenses.mit
      lib.licenses.gpl2Plus
      lib.licenses.free
    ];
    description = "Library for the solution of large, sparse, nonsymmetric systems of linear equations";
    platforms = lib.platforms.unix;
  };
})
