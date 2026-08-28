{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  fftw,
  hdf5,
  libjpeg,
  libpng,
  libtiff,
  openexr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vigra";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "ukoethe";
    repo = "vigra";
    tag = "Version-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-ZmHj1BSyoMBCuxI5hrRiBEb5pDUsGzis+T5FSX27UN8=";
  };

  patches = [
    ./fix-llvm-19-1.patch
    ./fix-llvm-19-2.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    boost
    fftw
    hdf5
    libjpeg
    libpng
    libtiff
    openexr
  ];

  postPatch = ''
    chmod +x config/run_test.sh.in
    patchShebangs --build config/run_test.sh.in
  '';

  cmakeFlags = [
    "-DWITH_OPENEXR=1"
    "-DWITH_VIGRANUMPY=0"
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    "-DCMAKE_CXX_FLAGS=-fPIC"
    "-DCMAKE_C_FLAGS=-fPIC"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Novel computer vision C++ library with customizable algorithms and data structures";
    mainProgram = "vigra-config";
    homepage = "https://hci.iwr.uni-heidelberg.de/vigra";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
