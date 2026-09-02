{
  lib,
  stdenv,
  fetchFromGitHub,
  cairo,
  libxkbcommon,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slurp";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2M8f3kN6tihwKlUCp2Qowv5xD6Ufb71AURXqwQShlXI=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    scdoc
  ];

  buildInputs = [
    cairo
    libxkbcommon
    wayland
    wayland-protocols
  ];

  strictDeps = true;

  mesonFlags = [ (lib.mesonEnable "man-pages" true) ];

  meta = {
    description = "Select a region in a Wayland compositor";
    platforms = lib.platforms.linux;
    homepage = "https://github.com/emersion/slurp";
    license = lib.licenses.mit;
    mainProgram = "slurp";
  };
})
