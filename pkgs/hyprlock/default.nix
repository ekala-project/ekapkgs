{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libxkbcommon,
  hyprgraphics,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  pam,
  sdbus-cpp_2,
  systemdLibs,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cairo,
  file,
  libjpeg,
  libwebp,
  pango,
  libdrm,
  libgbm,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprlock";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprlock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VFlM1cN4jmUAbfmZbeg7vL+AN9miXEUqqpk5EkHNq2c=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    hyprwayland-scanner
    wayland-scanner
  ];

  buildInputs = [
    cairo
    file
    hyprgraphics
    hyprlang
    hyprutils
    libdrm
    libGL
    libjpeg
    libwebp
    libxkbcommon
    libgbm
    pam
    pango
    sdbus-cpp_2
    systemdLibs
    wayland
    wayland-protocols
  ];

  postInstall = ''
    mkdir -p $out/etc/xdg/hypr
    ln -s $out/share/hypr/hyprlock.conf $out/etc/xdg/hypr/hyprlock.conf
  '';

  meta = {
    description = "Hyprland's GPU-accelerated screen locking utility";
    homepage = "https://github.com/hyprwm/hyprlock";
    changelog = "https://github.com/hyprwm/hyprlock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "hyprlock";
    platforms = lib.platforms.linux;
  };
})
