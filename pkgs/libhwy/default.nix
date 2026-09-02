{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-YUYZO9KLffczjwIz3mBBceD6oM1giLCFLDHgDCevdRA=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  dontUseCmakeBuildDir = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DHWY_ENABLE_TESTS=OFF"
  ];

  meta = {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.unix;
  };
}
