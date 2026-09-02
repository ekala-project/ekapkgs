{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  giflib,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  openjpeg,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "leptonica";
  version = "1.87.0";

  src = fetchFromGitHub {
    owner = "DanBloomBerg";
    repo = "leptonica";
    rev = finalAttrs.version;
    hash = "sha256-d67gxWmWN3WfSPuHrjpC+emLyQswJbKV7gzm7D4bpI0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    giflib
    libjpeg
    libpng
    libtiff
    libwebp
    openjpeg
    zlib
  ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    description = "Image processing and analysis library";
    homepage = "http://www.leptonica.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
