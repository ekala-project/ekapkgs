{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  liblo,
  libjack2,
  fltk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "new-session-manager";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "jackaudio";
    repo = "new-session-manager";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5G2GlBuKjC/r1SMm78JKia7bMA97YcvUR5l6zBucemw=";
  };

  nativeBuildInputs = [
    fltk
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    fltk
    liblo
    libjack2
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://new-session-manager.jackaudio.org/";
    description = "Session manager designed for audio applications";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
})
