{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  which,
  m4,
  python3,
  bison,
  flex,
  llvmPackages,
  ncurses,
  onetbb ? null,
  testedTargets ?
    if stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32 then
      [ "neon-i32x4" ]
    else
      [ "sse2-i32x4" ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ispc";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "ispc";
    repo = "ispc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n1zWokIuZEDJZN/KH3jxnIhgUo8iKDfZwiQnXZdxhL8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    which
    m4
    bison
    flex
    python3
    llvmPackages.libllvm.dev
  ]
  ++ lib.optionals (onetbb != null) [ onetbb ];

  buildInputs =
    with llvmPackages;
    [
      libllvm
      libclang
    ]
    ++ lib.optionals (llvmPackages ? openmp) [ llvmPackages.openmp ]
    ++ [
      ncurses
    ];

  inherit testedTargets;

  doCheck = true;

  hardeningDisable = [ "strictoverflow" ];

  checkPhase = ''
    export ISPC_HOME=$PWD/bin
    for target in $testedTargets
    do
      echo "Testing target $target"
      echo "================================"
      echo
      (cd ../
       PATH=${llvmPackages.clang}/bin:$PATH python scripts/run_tests.py -t $target --non-interactive --verbose --file=test_output.log
       fgrep -q "No new fails"  test_output.log || exit 1)
    done
  '';

  cmakeFlags = [
    (lib.cmakeFeature "FILE_CHECK_EXECUTABLE" "${llvmPackages.llvm}/bin/FileCheck")
    (lib.cmakeFeature "LLVM_AS_EXECUTABLE" "${llvmPackages.llvm}/bin/llvm-as")
    (lib.cmakeFeature "LLVM_CONFIG_EXECUTABLE" "${llvmPackages.llvm.dev}/bin/llvm-config")
    (lib.cmakeFeature "CLANG_EXECUTABLE" "${llvmPackages.clang}/bin/clang")
    (lib.cmakeFeature "CLANGPP_EXECUTABLE" "${llvmPackages.clang}/bin/clang++")
    (lib.cmakeBool "ISPC_INCLUDE_EXAMPLES" false)
    (lib.cmakeBool "ISPC_INCLUDE_UTILS" false)
    (lib.cmakeBool "XE_ENABLED" false)
    (lib.cmakeBool "ARM_ENABLED" (stdenv.hostPlatform.isAarch64 || stdenv.hostPlatform.isAarch32))
    (lib.cmakeBool "X86_ENABLED" (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isx86_32))
  ];

  meta = {
    description = "Intel 'Single Program, Multiple Data' Compiler, a vectorised language";
    homepage = "https://ispc.github.io/";
    changelog = "https://github.com/ispc/ispc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "ispc";
    platforms = lib.platforms.linux;
  };
})
