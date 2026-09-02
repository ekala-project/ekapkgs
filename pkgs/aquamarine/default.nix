{
  lib,
  gcc15Stdenv,
  cmake,
  fetchFromGitHub,
  hwdata,
  hyprutils,
  hyprwayland-scanner,
  libdisplay-info,
  libdrm,
  libffi,
  libGL,
  libinput,
  libgbm,
  pixman,
  pkg-config,
  seatd,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "aquamarine";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "aquamarine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cUQENbJn0PHQUttXame5+PbGGew+BckHZFTfpb8XGI8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    hyprwayland-scanner
    pkg-config
  ];

  buildInputs = [
    hwdata
    hyprutils
    libdisplay-info
    libdrm
    libffi
    libGL
    libinput
    libgbm
    pixman
    seatd
    udev
    wayland
    wayland-protocols
    wayland-scanner
  ];

  strictDeps = true;

  outputs = [
    "out"
    "dev"
  ];

  cmakeBuildType = "RelWithDebInfo";

  meta = {
    changelog = "https://github.com/hyprwm/aquamarine/releases/tag/v${finalAttrs.version}";
    description = "Very light linux rendering backend library";
    homepage = "https://github.com/hyprwm/aquamarine";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
