{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  zlib,
  ffmpeg-headless ? null,
  freetype ? null,
  libjpeg_turbo ? null,
  libpng ? null,
  libmad ? null,
  faad2 ? null,
  libogg ? null,
  libvorbis ? null,
  libtheora ? null,
  a52dec ? null,
  nghttp2 ? null,
  openjpeg ? null,
  libcaca ? null,
  mesa_glu ? null,
  xvidcore ? null,
  openssl ? null,
  jack2 ? null,
  alsa-lib ? null,
  pulseaudio ? null,
  SDL2 ? null,
  curl ? null,
  libxv ? null,
  libx11 ? null,
  xorgproto ? null,
  withFullDeps ? false,
  withFfmpeg ? withFullDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpac";
  version = "26.07.0";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${finalAttrs.version}";
    hash = "sha256-L4GKXCFsKVxWXZJJeiAegXJySoS9+/V+/cuzEJEse+I=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (withFfmpeg && ffmpeg-headless != null) [
    ffmpeg-headless
  ];

  buildInputs = [
    zlib
  ]
  ++ lib.optionals withFullDeps (
    lib.filter (x: x != null) [
      freetype
      libjpeg_turbo
      libpng
      libmad
      faad2
      libogg
      libvorbis
      libtheora
      a52dec
      nghttp2
      openjpeg
      libcaca
      libx11
      libxv
      xorgproto
      mesa_glu
      xvidcore
      openssl
      jack2
      alsa-lib
      pulseaudio
      SDL2
      curl
    ]
  );

  enableParallelBuilding = true;

  meta = {
    description = "Open Source multimedia framework for research and academic purposes";
    homepage = "https://gpac.wp.imt.fr";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
