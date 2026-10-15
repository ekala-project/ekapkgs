{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  llvmPackages,
  wasm-tools,
}:

let
  # Build compiler-rt builtins for wasm32 using the host clang
  compiler-rt-wasm32 = stdenv.mkDerivation {
    pname = "compiler-rt-wasm32";
    version = llvmPackages.llvm.version;

    src = llvmPackages.llvm.monorepoSrc;
    sourceRoot = "${llvmPackages.llvm.monorepoSrc.name}/compiler-rt";

    __structuredAttrs = true;

    nativeBuildInputs = [
      cmake
      ninja
      llvmPackages.clang-unwrapped
      llvmPackages.lld
    ];

    cmakeFlags = [
      (lib.cmakeFeature "CMAKE_C_COMPILER" "${llvmPackages.clang-unwrapped}/bin/clang")
      (lib.cmakeFeature "CMAKE_C_COMPILER_TARGET" "wasm32-unknown-wasip1")
      (lib.cmakeFeature "CMAKE_AR" "${llvmPackages.llvm}/bin/llvm-ar")
      (lib.cmakeFeature "CMAKE_NM" "${llvmPackages.llvm}/bin/llvm-nm")
      (lib.cmakeFeature "CMAKE_RANLIB" "${llvmPackages.llvm}/bin/llvm-ranlib")
      (lib.cmakeFeature "CMAKE_C_FLAGS" "-nodefaultlibs --target=wasm32-unknown-wasip1 -fuse-ld=${llvmPackages.lld}/bin/wasm-ld")
      (lib.cmakeFeature "CMAKE_SYSTEM_NAME" "WASI")
      (lib.cmakeFeature "CMAKE_SYSTEM_PROCESSOR" "wasm32")
      (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
      (lib.cmakeFeature "CMAKE_TRY_COMPILE_TARGET_TYPE" "STATIC_LIBRARY")
      (lib.cmakeBool "COMPILER_RT_DEFAULT_TARGET_ONLY" true)
      (lib.cmakeBool "COMPILER_RT_BAREMETAL_BUILD" true)
      (lib.cmakeBool "COMPILER_RT_BUILD_LIBFUZZER" false)
      (lib.cmakeBool "COMPILER_RT_BUILD_MEMPROF" false)
      (lib.cmakeBool "COMPILER_RT_BUILD_PROFILE" false)
      (lib.cmakeBool "COMPILER_RT_BUILD_SANITIZERS" false)
      (lib.cmakeBool "COMPILER_RT_BUILD_XRAY" false)
      (lib.cmakeBool "COMPILER_RT_BUILD_ORC" false)
    ];

    meta = {
      description = "Compiler-RT builtins for wasm32";
      license = with lib.licenses; [ asl20 llvm-exception ];
      platforms = lib.platforms.linux;
    };
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wasilibc";
  version = "32";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "wasi-libc";
    tag = "wasi-sdk-${finalAttrs.version}";
    hash = "sha256-iP/SFYvO8zQMwwbY4VvIboO+Kx195L9brpMq8cbsA7c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.clang-unwrapped
    llvmPackages.lld
    ninja
    wasm-tools
  ];

  outputs = [
    "out"
    "dev"
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_C_COMPILER" "${llvmPackages.clang-unwrapped}/bin/clang")
    (lib.cmakeFeature "CMAKE_C_COMPILER_TARGET" "wasm32-unknown-wasip1")
    (lib.cmakeFeature "CMAKE_AR" "${llvmPackages.llvm}/bin/llvm-ar")
    (lib.cmakeFeature "CMAKE_NM" "${llvmPackages.llvm}/bin/llvm-nm")
    (lib.cmakeFeature "CMAKE_RANLIB" "${llvmPackages.llvm}/bin/llvm-ranlib")
    (lib.cmakeFeature "CMAKE_SYSTEM_NAME" "WASI")
    (lib.cmakeFeature "CMAKE_SYSTEM_PROCESSOR" "wasm32")
    (lib.cmakeBool "CMAKE_CROSSCOMPILING" true)
    (lib.cmakeFeature "CMAKE_TRY_COMPILE_TARGET_TYPE" "STATIC_LIBRARY")
    (lib.cmakeFeature "TARGET_TRIPLE" "wasm32-unknown-wasip1")
    (lib.cmakeFeature "BUILTINS_LIB" "${compiler-rt-wasm32}/lib/wasi/libclang_rt.builtins-wasm32.a")
    (lib.cmakeFeature "USE_WASM_COMPONENT_LD" "OFF")
    # Don't try to generate P2/P3 bindings (needs wit-bindgen and wkg)
    (lib.cmakeBool "BINDINGS_TARGET" false)
  ];

  enableParallelBuilding = true;

  passthru = {
    inherit compiler-rt-wasm32;
    incdir = "/include/wasm32-unknown-wasip1";
    libdir = "/lib/wasm32-unknown-wasip1";
  };

  meta = {
    description = "WASI libc implementation for WebAssembly";
    homepage = "https://wasi.dev";
    license = with lib.licenses; [ asl20 llvm-exception mit ];
    platforms = lib.platforms.linux;
  };
})
