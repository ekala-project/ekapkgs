{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  aml,
  ffmpeg,
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "neatvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yEWNiazRxc8G7ToqOcTtCXEuBCgXO64v31Xx1YeOPCM=";
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
    ffmpeg
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
  ];

  meta = {
    description = "VNC server library";
    homepage = "https://github.com/any1/neatvnc";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
