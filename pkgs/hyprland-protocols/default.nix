{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-protocols";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-protocols";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g09dB6NCTzD4F6YgYrGXRhUfG52xwxUtlMAbHvv/1gE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    homepage = "https://github.com/hyprwm/hyprland-protocols";
    description = "Wayland protocol extensions for Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
