{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pugixml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprwayland-scanner";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprwayland-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jxixw6wZphUp+nHYxOKUYSckL17QMBx2d5Zp0rJHr1g=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    pugixml
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/hyprwm/hyprwayland-scanner";
    description = "Hyprland version of wayland-scanner in and for C++";
    changelog = "https://github.com/hyprwm/hyprwayland-scanner/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "hyprwayland-scanner";
    platforms = lib.platforms.linux;
  };
})
