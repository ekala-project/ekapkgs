{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xdg-utils,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wl-clipboard";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c/EfjrA4H/MiedSVWLN6ZUipxwcsmBueeYJu5b09MGc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wayland-scanner
    makeWrapper
  ];

  buildInputs = [
    wayland
    wayland-protocols
  ];

  mesonFlags = [
    "-Dfishcompletiondir=share/fish/vendor_completions.d"
  ];

  postInstall = ''
    wrapProgram $out/bin/wl-copy \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = {
    homepage = "https://github.com/bugaevc/wl-clipboard";
    description = "Command-line copy/paste utilities for Wayland";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
