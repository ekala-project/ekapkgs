{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  bison,
  flex,
  bzip2,
  xz,
  zlib,
  mpi,
  mpiCheckPhaseHook ? null,
  withPtScotch ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scotch";
  version = "7.0.12";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "scotch";
    repo = "scotch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DE0VCGCSOOeSRIz/LQPCBNSBTNmXQtYAUKm3EeqnDBs=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_PTSCOTCH" withPtScotch)
    (lib.cmakeBool "SCOTCH_METIS_PREFIX" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gfortran
    bison
    flex
  ];

  buildInputs = [
    bzip2
    xz
    zlib
  ];

  propagatedBuildInputs = lib.optionals withPtScotch [
    mpi
  ];

  nativeCheckInputs = lib.optionals (withPtScotch && mpiCheckPhaseHook != null) [
    mpiCheckPhaseHook
  ];

  doCheck = true;

  postFixup = ''
    mkdir -p $dev/include/scotch
    mv $dev/include/{*metis,metisf}.h $dev/include/scotch
  '';

  meta = {
    description = "Graph and mesh/hypergraph partitioning, graph clustering, and sparse matrix ordering";
    longDescription = ''
      Scotch is a software package for graph and mesh/hypergraph partitioning, graph clustering,
      and sparse matrix ordering.
    '';
    homepage = "http://www.labri.fr/perso/pelegrin/scotch";
    license = lib.licenses.cecill-c;
  };
})
