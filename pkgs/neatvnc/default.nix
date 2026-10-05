{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  aml,
  gnutls,
  libdrm,
  libjpeg_turbo,
  libgbm,
  nettle,
  pixman,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neatvnc";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yL15sr/Oi0CgXDQl4qPUL7vya3HWL+chRiwHsIQ2ADI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    aml
    gnutls
    libdrm
    libjpeg_turbo
    libgbm
    nettle
    pixman
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "tests" false)
    (lib.mesonEnable "h264" false)
  ];

  meta = {
    description = "VNC server library";
    homepage = "https://github.com/any1/neatvnc";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
  };
})
