{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  autogen,
  pkg-config,
  python3,
  flac,
  lame,
  libmpg123,
  libogg,
  libopus,
  libvorbis,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsndfile";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "libsndfile";
    repo = "libsndfile";
    rev = finalAttrs.version;
    hash = "sha256-MOOX/O0UaoeMaQPW9PvvE0izVp+6IoE5VbtTx0RvMkI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/libsndfile/libsndfile/commit/2251737b3b175925684ec0d37029ff4cb521d302.patch";
      hash = "sha256-LaeptEicnjpVBExlK4dNMlN8+AAJhW8dIvemF6S4W2M=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    autogen
    pkg-config
    python3
  ];

  buildInputs = [
    flac
    lame
    libmpg123
    libogg
    libopus
    libvorbis
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  enableParallelBuilding = true;

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "doc"
  ];

  env.NIX_CFLAGS_LINK = toString [
    "-logg"
    "-lvorbis"
  ];

  meta = {
    description = "C library for reading and writing files containing sampled sound";
    homepage = "https://libsndfile.github.io/libsndfile/";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
