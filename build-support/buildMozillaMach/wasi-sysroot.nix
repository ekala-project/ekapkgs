# Builds a WASI sysroot with libc++ for Firefox's RLBox WASM sandboxing.
#
# This constructs:
# 1. compiler-rt builtins for wasm32
# 2. wasilibc (wasi-libc)
# 3. libc++ built on top of the above
# 4. A combined sysroot directory
# 5. Wrapper scripts for WASM_CC and WASM_CXX
{
  lib,
  stdenv,
  cmake,
  ninja,
  python3,
  llvmPackages,
  wasilibc,
  runCommand,
  writeShellScript,
}:

let
  compiler-rt-wasm32 = wasilibc.compiler-rt-wasm32;

  # Build libc++ for wasm32-wasip1 using wasilibc as the sysroot
  libcxx-wasm32 = stdenv.mkDerivation {
    pname = "libcxx-wasm32";
    version = llvmPackages.llvm.version;

    src = llvmPackages.llvm.monorepoSrc;
    sourceRoot = "${llvmPackages.llvm.monorepoSrc.name}/runtimes";

    __structuredAttrs = true;

    nativeBuildInputs = [
      cmake
      cmake.configurePhaseHook
      ninja
      python3
    ];

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_C_COMPILER" "${llvmPackages.clang-unwrapped}/bin/clang")
      (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${llvmPackages.clang-unwrapped}/bin/clang++")
      (lib.cmakeFeature "CMAKE_C_COMPILER_TARGET" "wasm32-unknown-wasip1")
      (lib.cmakeFeature "CMAKE_CXX_COMPILER_TARGET" "wasm32-unknown-wasip1")
      (lib.cmakeFeature "CMAKE_AR" "${llvmPackages.llvm}/bin/llvm-ar")
      (lib.cmakeFeature "CMAKE_NM" "${llvmPackages.llvm}/bin/llvm-nm")
      (lib.cmakeFeature "CMAKE_RANLIB" "${llvmPackages.llvm}/bin/llvm-ranlib")
      (lib.cmakeFeature "CMAKE_C_FLAGS" "--target=wasm32-unknown-wasip1 --sysroot=${wasilibc} -I${wasilibc.dev}${wasilibc.incdir} -fuse-ld=${llvmPackages.lld}/bin/wasm-ld")
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "--target=wasm32-unknown-wasip1 --sysroot=${wasilibc} -I${wasilibc.dev}${wasilibc.incdir} -fuse-ld=${llvmPackages.lld}/bin/wasm-ld")
      (lib.cmakeFeature "CMAKE_SYSTEM_NAME" "WASI")
      (lib.cmakeFeature "CMAKE_SYSTEM_PROCESSOR" "wasm32")
      (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
      (lib.cmakeFeature "CMAKE_TRY_COMPILE_TARGET_TYPE" "STATIC_LIBRARY")
      (lib.cmakeFeature "CMAKE_SYSROOT" "${wasilibc}")
      # Only build libc++ and libc++abi
      (lib.cmakeFeature "LLVM_ENABLE_RUNTIMES" "libcxx;libcxxabi")
      # libc++ configuration for wasm
      (lib.cmakeBool "LIBCXX_ENABLE_SHARED" false)
      (lib.cmakeBool "LIBCXX_ENABLE_EXCEPTIONS" false)
      (lib.cmakeBool "LIBCXX_ENABLE_FILESYSTEM" false)
      (lib.cmakeBool "LIBCXX_ENABLE_THREADS" false)
      (lib.cmakeBool "LIBCXX_ENABLE_MONOTONIC_CLOCK" false)
      (lib.cmakeBool "LIBCXX_HAS_EXTERNAL_THREAD_API" false)
      (lib.cmakeBool "LIBCXX_HAS_WIN32_THREAD_API" false)
      (lib.cmakeBool "LIBCXX_HAS_PTHREAD_API" false)
      (lib.cmakeBool "LIBCXX_HAS_MUSL_LIBC" false)
      (lib.cmakeFeature "LIBCXX_CXX_ABI" "libcxxabi")
      (lib.cmakeBool "LIBCXX_INCLUDE_BENCHMARKS" false)
      # libc++abi configuration
      (lib.cmakeBool "LIBCXXABI_ENABLE_SHARED" false)
      (lib.cmakeBool "LIBCXXABI_ENABLE_EXCEPTIONS" false)
      (lib.cmakeBool "LIBCXXABI_ENABLE_THREADS" false)
      (lib.cmakeBool "LIBCXXABI_HAS_EXTERNAL_THREAD_API" false)
      (lib.cmakeBool "LIBCXXABI_HAS_WIN32_THREAD_API" false)
      (lib.cmakeBool "LIBCXXABI_HAS_PTHREAD_API" false)
      (lib.cmakeBool "LIBCXXABI_SILENT_TERMINATE" true)
      # Use compiler-rt builtins
      (lib.cmakeFeature "LIBCXX_USE_COMPILER_RT" "ON")
      (lib.cmakeFeature "LIBCXXABI_USE_COMPILER_RT" "ON")
      (lib.cmakeFeature "COMPILER_RT_LIBRARY_builtins_wasm32" "${compiler-rt-wasm32}/lib/wasi/libclang_rt.builtins-wasm32.a")
    ];

    enableParallelBuilding = true;

    meta = {
      description = "libc++ for wasm32-wasip1";
      license = with lib.licenses; [
        asl20
        llvm-exception
      ];
      platforms = lib.platforms.linux;
    };
  };

  # Assemble the wasi sysroot with libc++ (this is what --with-wasi-sysroot points to)
  wasiSysRoot = runCommand "wasi-sysroot" { } ''
    mkdir -p $out/lib/wasm32-wasip1
    # Link libc++ libraries
    for lib in ${libcxx-wasm32}/lib/*; do
      ln -s $lib $out/lib/wasm32-wasip1/
    done
  '';

  # Create a clang wrapper that targets wasm32-wasip1
  wasiCC = writeShellScript "wasm32-unknown-wasip1-cc" ''
    exec ${llvmPackages.clang-unwrapped}/bin/clang \
      --target=wasm32-unknown-wasip1 \
      --sysroot=${wasilibc} \
      -I${wasilibc.dev}${wasilibc.incdir} \
      -fuse-ld=${llvmPackages.lld}/bin/wasm-ld \
      -resource-dir ${compiler-rt-wasm32} \
      "$@"
  '';

  wasiCXX = writeShellScript "wasm32-unknown-wasip1-c++" ''
    exec ${llvmPackages.clang-unwrapped}/bin/clang++ \
      --target=wasm32-unknown-wasip1 \
      --sysroot=${wasilibc} \
      -I${wasilibc.dev}${wasilibc.incdir} \
      -fuse-ld=${llvmPackages.lld}/bin/wasm-ld \
      -resource-dir ${compiler-rt-wasm32} \
      "$@"
  '';

  # Create a bin directory with the wrapper scripts
  wasiBin = runCommand "wasi-cc" { } ''
    mkdir -p $out/bin
    cp ${wasiCC} $out/bin/wasm32-unknown-wasip1-cc
    cp ${wasiCXX} $out/bin/wasm32-unknown-wasip1-c++
    chmod +x $out/bin/*
  '';
in
{
  inherit
    wasiSysRoot
    wasiBin
    wasiCC
    wasiCXX
    compiler-rt-wasm32
    libcxx-wasm32
    ;
}
