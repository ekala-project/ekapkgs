{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libhwy";
  version = "1.4.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "google";
    repo = "highway";
    tag = finalAttrs.version;
    hash = "sha256-YUYZO9KLffczjwIz3mBBceD6oM1giLCFLDHgDCevdRA=";
  };

  patches = lib.optionals stdenv.hostPlatform.isAarch64 [
    # backport GCC 16/aarch64 fix
    (fetchpatch {
      url = "https://github.com/google/highway/commit/8a0da774fe6b3f9ab02f5f33e763b8c2133f38fc.patch";
      hash = "sha256-uAWBtQWE/iSFK0Ht3rWV+kpSH/UPQr8nlM9AWBFu0Vg=";
    })
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isAarch64 [
    "trivialautovarinit"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  # Required for case-insensitive filesystems ("BUILD" exists)
  dontUseCmakeBuildDir = true;

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
    CMAKE_INSTALL_INCLUDEDIR = "include";
    BUILD_SHARED_LIBS = !stdenv.hostPlatform.isStatic;
    HWY_ENABLE_TESTS = false;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32 {
    HWY_CMAKE_ARM7 = true;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isx86_32 {
    HWY_CMAKE_SSE2 = true;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isRiscV {
    HWY_CMAKE_RVV = false;
  };

  # Consumers rely on test headers being exported
  postInstall = ''
    install -Dm644 hwy/tests/*.h -t $out/include/hwy/tests/
  '';

  postFixup = ''
    substituteInPlace $dev/lib/cmake/hwy/hwy-config-release.cmake \
      --replace-fail "\''${_IMPORT_PREFIX}/lib" "$out/lib"
  '';

  meta = {
    description = "Performance-portable, length-agnostic SIMD with runtime dispatch";
    homepage = "https://github.com/google/highway";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [
      "libhwy"
      "libhwy-contrib"
    ];
  };
})
