{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  hwloc,
  fftw,
  fftwSinglePrec,
  perl,
  python3,
  blas,
  lapack,
  singlePrec ? true,
  enableMpi ? false,
  mpi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gromacs";
  version = "2026.4";

  src = fetchurl {
    url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-${finalAttrs.version}.tar.gz";
    hash = "sha256-WO2mCXmxJPz53/ixtjzt+8cv2zbZnpIdwb3DEFcQmLY=";
  };

  patches = [
    ./pkgconfig-2025.patch
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    (if singlePrec then fftwSinglePrec else fftw)
    perl
    python3
    hwloc
    blas
    lapack
  ]
  ++ lib.optionals enableMpi [ mpi ];

  propagatedBuildInputs = lib.optionals enableMpi [ mpi ];

  cmakeFlags = [
    (lib.cmakeBool "GMX_HWLOC" true)
    (lib.cmakeBool "GMX_OPENMP" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "GMX_DOUBLE" (!singlePrec))
    (lib.cmakeBool "GMX_DEFAULT_SUFFIX" singlePrec)
    (lib.cmakeBool "GMX_MPI" enableMpi)
  ]
  ++ lib.optionals enableMpi [
    (lib.cmakeBool "GMX_THREAD_MPI" false)
  ];

  postInstall = ''
    moveToOutput share/cmake $dev
  '';

  meta = {
    homepage = "https://www.gromacs.org";
    license = lib.licenses.lgpl21Plus;
    description = "Molecular dynamics software package";
    platforms = lib.platforms.unix;
  };
})
