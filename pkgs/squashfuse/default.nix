{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  fuse,
  pkg-config,
  lz4,
  xz,
  zlib,
  lzo,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "squashfuse";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "vasi";
    repo = "squashfuse";
    rev = finalAttrs.version;
    sha256 = "sha256-P7YMKmuXGlWBFQlaclxWveVofC+tcerB6iqMvQpVdS0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  buildInputs = [
    lz4
    xz
    zlib
    lzo
    zstd
    fuse
  ];

  meta = {
    description = "FUSE filesystem to mount squashfs archives";
    homepage = "https://github.com/vasi/squashfuse";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
})
