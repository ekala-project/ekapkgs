{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libdrm,
  ncurses,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvtop";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "Syllo";
    repo = "nvtop";
    tag = finalAttrs.version;
    hash = "sha256-w3g/9VbZz1qrEMaBBHEf9Y93z0vo8LbWnENL2wEEaSw=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "USE_LIBUDEV_OVER_LIBSYSTEMD" true)
    (lib.cmakeBool "AMDGPU_SUPPORT" true)
    (lib.cmakeBool "NVIDIA_SUPPORT" true)
    (lib.cmakeBool "INTEL_SUPPORT" true)
    (lib.cmakeBool "MSM_SUPPORT" true)
    (lib.cmakeBool "PANFROST_SUPPORT" true)
    (lib.cmakeBool "PANTHOR_SUPPORT" true)
    (lib.cmakeBool "V3D_SUPPORT" true)
    (lib.cmakeBool "ROCKCHIP_SUPPORT" true)
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    ncurses
    udev
    libdrm
  ];

  env.NIX_CFLAGS_COMPILE = "-isystem ${lib.getDev libdrm}/include/libdrm";

  meta = {
    description = "htop-like task monitor for AMD, Adreno, Intel and NVIDIA GPUs";
    homepage = "https://github.com/Syllo/nvtop";
    changelog = "https://github.com/Syllo/nvtop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "nvtop";
  };
})
