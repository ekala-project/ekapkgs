{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsixel";
  version = "1.10.5";

  src = fetchFromGitHub {
    owner = "libsixel";
    repo = "libsixel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-obzBZAknN3N7+Bvtd0+JHuXcemVb7wRv+Pt4VjS6Bck=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  doCheck = true;

  mesonFlags = [
    "-Dtests=enabled"
    "-Dimg2sixel=enabled"
    "-Dsixel2png=enabled"
    "-Dgd=disabled"
    "-Djpeg=disabled"
    "-Dpng=disabled"
  ];

  meta = {
    description = "SIXEL library for console graphics, and converter programs";
    homepage = "https://github.com/libsixel/libsixel";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
