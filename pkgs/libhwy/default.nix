{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "libhwy";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    rev = version;
    hash = "sha256-8QOk96Y3GIIvBUGIDikMgTylx8y5aCyr68/TP5w5ha4=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-15-clone-hack-prerequisite.patch";
      url = "https://github.com/google/highway/commit/3b680cde3a556bead9cc23c8f595d07a44d5a0d5.patch";
      hash = "sha256-8xBPuhsifalhzKgeEOQq6yZw2NWas+SFQrNIaMicRnY=";
    })
    (fetchpatch {
      name = "gcc-15-clone-hack.patch";
      url = "https://github.com/google/highway/commit/5af21b8a9078330a3d7456d855e69245bb87bc7a.patch";
      hash = "sha256-hC/oEdxHsdZKlLFIw929ZHjffPURGzk9jiKz6iGSLkY=";
    })
  ];

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
    maintainers = [ ];
  };
}
