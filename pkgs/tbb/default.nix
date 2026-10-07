{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "tbb";
  version = "2023.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-7C6h2wcQW/t3J6/PX+aoRFHeHpy0s0km9ZLvxvOBdpY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  patches = [
    # Fix musl build from https://github.com/oneapi-src/oneTBB/pull/899
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/899.patch";
      hash = "sha256-kU6RRX+sde0NrQMKlNtW3jXav6J4QiVIUmD50asmBPU=";
    })
  ];

  patchFlags = [
    "-p1"
    "--ignore-whitespace"
  ];

  cmakeFlags = [
    "-DTBB_TEST=OFF"
  ];

  # Fix build with modern gcc
  NIX_CFLAGS_COMPILE =
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=array-bounds"
      "-Wno-error=stringop-overflow"
    ]
    ++ lib.optionals stdenv.cc.isClang [ "-Wno-error=unused-but-set-variable" ]
    ++ lib.optionals (stdenv.cc.isGNU && stdenv.hostPlatform.isx86_32) [ "-O2" ];

  # Fix undefined reference errors with version script under LLVM.
  NIX_LDFLAGS = lib.optionalString (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) "--undefined-version";

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail 'tbb_add_test(SUBDIR conformance NAME conformance_resumable_tasks DEPENDENCIES TBB::tbb)' ""
  '';


  meta = {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = lib.licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = lib.platforms.unix;
  };
}
