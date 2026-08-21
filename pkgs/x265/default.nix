{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  nasm,
  numactl,
}:

let
  numaSupport =
    stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64);
  multibitdepthSupport = stdenv.hostPlatform.is64bit;
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "x265";
  version = "4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://bitbucket.org/multicoreware/x265_git/downloads/x265_${finalAttrs.version}.tar.gz";
    hash = "sha256-oxaZxqiYBrdLAVHl5qffZd5LSQUEgv5ev4pDedevjyk=";
  };

  patches = [
    ./darwin-__rdtsc.patch
    ./gcc15-fixes.patch
    (fetchpatch {
      name = "x265-fix-cmake-4-1.patch";
      url = "https://bitbucket.org/multicoreware/x265_git/commits/b354c009a60bcd6d7fc04014e200a1ee9c45c167/raw";
      stripLen = 1;
      hash = "sha256-kS+hYZb5dnIlNoZ8ABmNkLkPx+NqCPy+DonXktBzJAE=";
    })
    (fetchpatch {
      name = "x265-fix-cmake-4-2.patch";
      url = "https://bitbucket.org/multicoreware/x265_git/commits/51ae8e922bcc4586ad4710812072289af91492a8/raw";
      stripLen = 1;
      hash = "sha256-ZrpyfSnijUgdyVscW73K48iEXa9k85ftNaQdr0HWSYg=";
    })
    (fetchpatch {
      name = "x265-fix-cmake-4-3.patch";
      url = "https://bitbucket.org/multicoreware/x265_git/commits/78e5ac35c13c5cbccc5933083edceb0d3eaeaa21/raw";
      stripLen = 1;
      hash = "sha256-qEihgUKGEdthbKz67s+/hS/qdpzl+3tEB3gx2tarax4=";
    })
  ];

  sourceRoot = "x265_${finalAttrs.version}/source";

  postPatch = ''
    substituteInPlace cmake/Version.cmake \
      --replace-fail "unknown" "${finalAttrs.version}" \
      --replace-fail "0.0" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    nasm
  ]
  ++ lib.optionals numaSupport [ numactl ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_ALPHA" true)
    (lib.cmakeBool "ENABLE_MULTIVIEW" true)
    (lib.cmakeBool "ENABLE_SCC_EXT" true)
    "-Wno-dev"
  ]
  ++ lib.optionals stdenv.hostPlatform.isPower [
    (lib.cmakeBool "ENABLE_ALTIVEC" false)
    (lib.cmakeBool "CPU_POWER8" (stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian))
  ];

  cmakeStaticLibFlags = [
    (lib.cmakeBool "HIGH_BIT_DEPTH" true)
    (lib.cmakeBool "ENABLE_CLI" false)
    (lib.cmakeBool "ENABLE_SHARED" false)
    (lib.cmakeBool "EXPORT_C_API" false)
  ]
  ++ lib.optionals isCross [
    (lib.cmakeBool "CROSS_COMPILE_ARM" stdenv.hostPlatform.isAarch32)
    (lib.cmakeBool "CROSS_COMPILE_ARM64" stdenv.hostPlatform.isAarch64)
  ];

  preConfigure =
    lib.optionalString multibitdepthSupport ''
      cmake -B build-10bits "''${cmakeFlags[@]}" "''${cmakeFlagsArray[@]}" "''${cmakeStaticLibFlags[@]}"
      cmake -B build-12bits "''${cmakeFlags[@]}" "''${cmakeFlagsArray[@]}" "''${cmakeStaticLibFlags[@]}" ${lib.cmakeBool "MAIN12" true}
      cmakeFlagsArray+=(
        ${lib.cmakeFeature "EXTRA_LIB" "\"x265-10.a;x265-12.a\""}
        ${lib.cmakeFeature "EXTRA_LINK_FLAGS" "-L."}
        ${lib.cmakeBool "LINKED_10BIT" true}
        ${lib.cmakeBool "LINKED_12BIT" true}
      )
    ''
    + ''
      cmakeFlagsArray+=(
        ${lib.cmakeBool "GIT_ARCHETYPE" true}
        ${lib.cmakeBool "ENABLE_SHARED" (!stdenv.hostPlatform.isStatic)}
        ${lib.cmakeBool "HIGH_BIT_DEPTH" false}
        ${lib.cmakeBool "ENABLE_HDR10_PLUS" true}
        ${lib.cmakeBool "ENABLE_CLI" true}
        ${lib.cmakeBool "ENABLE_TESTS" false}
      )
    '';

  preBuild = lib.optionalString multibitdepthSupport ''
    make -C ../build-10bits -j $NIX_BUILD_CORES
    make -C ../build-12bits -j $NIX_BUILD_CORES
    ln -s ../build-10bits/libx265.a ./libx265-10.a
    ln -s ../build-12bits/libx265.a ./libx265-12.a
  '';

  postInstall = ''
    rm -f ${placeholder "out"}/lib/*.a
  '';

  __structuredAttrs = true;

  meta = {
    description = "Library for encoding H.265/HEVC video streams";
    mainProgram = "x265";
    homepage = "https://www.x265.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
