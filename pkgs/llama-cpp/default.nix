{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  installShellFiles,
  openssl,
  addDriverRunpath,

  config,
  cudaSupport ? config.cudaSupport or false,
  cudaPackages ? { },

  blasSupport ? !cudaSupport,
  blas,

  vulkanSupport ? false,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
}:

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;
  inherit (lib) optionalAttrs optionals;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "10408";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b${finalAttrs.version}";
    hash = "sha256-b01kyCjcrAJ4zFPNRM2GU/9TR5y1mi7WIJDNYrhSJZo=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    installShellFiles
  ]
  ++ optionals cudaSupport [
    cudaPackages.cuda_nvcc
    addDriverRunpath
  ];

  buildInputs = [
    openssl
  ]
  ++ optionals blasSupport [ blas ]
  ++ optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cudart
      libcublas
    ]
  )
  ++ optionals vulkanSupport [
    shaderc
    vulkan-headers
    vulkan-loader
  ];

  cmakeEntries = {
    GGML_NATIVE = false;
    LLAMA_BUILD_EXAMPLES = false;
    LLAMA_BUILD_SERVER = true;
    LLAMA_BUILD_TESTS = false;
    LLAMA_OPENSSL = true;
    BUILD_SHARED_LIBS = true;
    GGML_BLAS = blasSupport;
    GGML_CUDA = cudaSupport;
    GGML_VULKAN = vulkanSupport;
    GGML_METAL = false;
    LLAMA_BUILD_NUMBER = finalAttrs.version;
    # Build CPU backend variants for runtime dynamic dispatch
    GGML_CPU_ALL_VARIANTS = true;
    GGML_BACKEND_DL = true;
  }
  // optionalAttrs cudaSupport {
    CMAKE_CUDA_ARCHITECTURES = cudaPackages.flags.cmakeCudaArchitecturesString;
  };

  preConfigure = ''
    prependToVar cmakeFlags "-DLLAMA_BUILD_COMMIT:STRING=$(cat COMMIT)"
  '';

  postInstall = ''
    mkdir -p $out/include
    cp $src/include/llama.h $out/include/
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd llama-server --bash <($out/bin/llama-server --completion-bash)
  '';

  meta = {
    description = "Inference of Meta's LLaMA model (and others) in pure C/C++";
    homepage = "https://github.com/ggml-org/llama.cpp";
    license = lib.licenses.mit;
    mainProgram = "llama-cli";
    platforms = lib.platforms.unix;
  };
})
