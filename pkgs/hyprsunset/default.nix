# hyprsunset — blue-light filter for Hyprland
{
  lib,
  gcc15Stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  hyprland-protocols,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsunset";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsunset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhrVi5f6n9eJv8kcDngb8j2P5F3i5/GCR77+qIWnjf4=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "hyprwayland-scanner>=0.4.0" ""
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    hyprwayland-scanner
  ];

  buildInputs = [
    hyprland-protocols
    hyprlang
    hyprutils
    wayland
    wayland-protocols
    wayland-scanner
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/hyprwm/hyprsunset";
    description = "Application to enable a blue-light filter on Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "hyprsunset";
  };
})
