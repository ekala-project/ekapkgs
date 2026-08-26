{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  wayland,
  wayland-protocols,
  wayland-scanner,
  hyprlang,
  hyprutils,
  hyprland-protocols,
  hyprwayland-scanner,
  sdbus-cpp_2,
  systemdLibs,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YzRWE3rCnsY0WDRJcn4KvyWUoe+5zdkUYNIaHGP9BZ4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    hyprwayland-scanner
    wayland-scanner
    hyprland-protocols
    wayland-protocols
  ];

  buildInputs = [
    hyprlang
    hyprutils
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    changelog = "https://github.com/hyprwm/hypridle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "hypridle";
    platforms = lib.platforms.linux;
  };
})
