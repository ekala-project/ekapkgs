{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
  opencv ? null,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ncnn";
  version = "20250503";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "ncnn";
    tag = finalAttrs.version;
    hash = "sha256-7wktoeei16QaPdcxVVS25sZYPhTQMEq9PjaHBwm5Eas=";
  };

  patches = [ ./cmakelists.patch ];

  cmakeEntries = {
    NCNN_CMAKE_VERBOSE = true;
    NCNN_SHARED_LIB = true;
    NCNN_ENABLE_LTO = true;
    NCNN_VULKAN = true;
    NCNN_BUILD_EXAMPLES = false;
    NCNN_BUILD_TOOLS = false;
    NCNN_SYSTEM_GLSLANG = true;
    NCNN_PYTHON = false;
  };

  cmakeFlags = # Requires setting `Vulkan_LIBRARY` on Darwin. Otherwise the build fails due to missing symbols. ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-DVulkan_LIBRARY=-lvulkan" ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
    opencv
    protobuf
  ];

  meta = {
    description = "Neural network inference framework";
    homepage = "https://github.com/Tencent/ncnn";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
