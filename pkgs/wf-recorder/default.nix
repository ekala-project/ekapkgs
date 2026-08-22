{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  wayland,
  wayland-protocols,
  ffmpeg,
  x264,
  libpulseaudio,
  pipewire,
  libgbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-recorder";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ammen99";
    repo = "wf-recorder";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CY0pci2LNeQiojyeES5323tN3cYfS3m4pECK85fpn5I=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    scdoc
  ];
  buildInputs = [
    wayland
    wayland-protocols
    ffmpeg
    x264
    libpulseaudio
    pipewire
    libgbm
  ];

  meta = {
    description = "Utility program for screen recording of wlroots-based compositors";
    homepage = "https://github.com/ammen99/wf-recorder";
    changelog = "https://github.com/ammen99/wf-recorder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "wf-recorder";
  };
})
