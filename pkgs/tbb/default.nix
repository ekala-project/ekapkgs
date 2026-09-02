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
  version = "2021.11.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-zGZHMtAUVzBKFbCshpepm3ce3tW6wQ+F30kYYXAQ/TE=";
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
    (fetchpatch {
      name = "fix-tbb-mingw-compile.patch";
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/1361.patch";
      hash = "sha256-jVa4HQetZv0vImdv549MyTy6/8t9dy8m6YAmjPGNQ18=";
    })
    (fetchpatch {
      name = "fix-tbb-mingw-link.patch";
      url = "https://patch-diff.githubusercontent.com/raw/oneapi-src/oneTBB/pull/1193.patch";
      hash = "sha256-ZQbwUmuIZoGVBof8QNR3V8vU385e2X7EvU3+Fbj4+M8=";
    })
    (fetchpatch {
      name = "fix-tbb-freebsd-and-windows-tests.patch";
      url = "https://patch-diff.githubusercontent.com/raw/uxlfoundation/oneTBB/pull/1696.patch";
      hash = "sha256-yjX2FkOK8bz29a/XSA7qXgQw9lxzx8VIgEBREW32NN4=";
    })
    (fetchpatch {
      name = "fix-cmake-threads-threads-target-for-static.patch";
      url = "https://patch-diff.githubusercontent.com/raw/uxlfoundation/oneTBB/pull/1248.patch";
      hash = "sha256-3WKzxU93vxuy7NgW+ap+ocZz5Q5utZ/pK7+FQExzLLA=";
    })
  ];

  patchFlags = [
    "-p1"
    "--ignore-whitespace"
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

  enableParallelBuilding = true;

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
