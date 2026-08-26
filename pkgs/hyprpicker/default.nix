{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  cairo,
  hyprutils,
  hyprwayland-scanner,
  libGL,
  libjpeg,
  libxkbcommon,
  pango,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxdmcp,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprpicker";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprpicker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ABumeksE8Bvtdb6g4vJ2jA9BLlYHnXU86VAuKJhBPoY=";
  };

  cmakeBuildType = "Release";

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    hyprwayland-scanner
    pkg-config
  ];

  buildInputs = [
    cairo
    hyprutils
    libGL
    libjpeg
    libxkbcommon
    pango
    wayland
    wayland-protocols
    wayland-scanner
    libxdmcp
  ];

  postInstall = ''
    mkdir -p $out/share/licenses
    install -Dm644 $src/LICENSE -t $out/share/licenses/hyprpicker
  '';

  meta = {
    description = "Wlroots-compatible Wayland color picker that does not suck";
    homepage = "https://github.com/hyprwm/hyprpicker";
    changelog = "https://github.com/hyprwm/hyprpicker/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "hyprpicker";
  };
})
