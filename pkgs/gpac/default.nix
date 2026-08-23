{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "26.02.0";

  src = fetchFromGitHub {
    owner = "gpac";
    repo = "gpac";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UtL+KG3dsp6dD7cfTK7e17ngt/RHKJL0s5IopTM3VOk=";
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/gpac/gpac/commit/cf6ac48c972eaaee2af270adc3f36615325deb3e.patch?full_index=1";
      hash = "sha256-JaJiQAQvzdB74ag2/aZTiQa2NqlgqgMYS1tsk/R+wiI=";
    })
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Open Source multimedia framework for research and academic purposes";
    homepage = "https://gpac.wp.imt.fr";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
