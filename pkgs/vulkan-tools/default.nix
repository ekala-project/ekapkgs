{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  cmake,
  pkg-config,
  python3,
  glslang,
  libffi,
  libx11,
  libxau,
  libxcb,
  libxdmcp,
  libxrandr,
  vulkan-headers,
  vulkan-loader,
  vulkan-volk,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "vulkan-tools";
  version = "1.4.341.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Tools";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-+5BL28h7+r+mLr1Tr7UT4UEB8jRrIc2JwoasJ7HzxI0=";
  };

  patches = [ ./wayland-scanner.patch ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs = [
    glslang
    vulkan-headers
    vulkan-loader
    vulkan-volk
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libffi
    libx11
    libxau
    libxcb
    libxdmcp
    libxrandr
    wayland
    wayland-protocols
  ];

  libraryPath = lib.strings.makeLibraryPath [ vulkan-loader ];

  dontPatchELF = true;

  env.PKG_CONFIG_WAYLAND_SCANNER_WAYLAND_SCANNER = lib.getExe buildPackages.wayland-scanner;

  cmakeFlags = [
    "-DBUILD_ICD=OFF"
    "-DCMAKE_INSTALL_RPATH=${libraryPath}"
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    "-Wno-dev"
  ];

  meta = {
    description = "Khronos official Vulkan Tools and Utilities";
    longDescription = ''
      This project provides Vulkan tools and utilities that can assist
      development by enabling developers to verify their applications correct
      use of the Vulkan API.
    '';
    homepage = "https://github.com/KhronosGroup/Vulkan-Tools";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
