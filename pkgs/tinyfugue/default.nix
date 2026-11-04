{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses,
  pcre2,
  zlib,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "tinyfugue";
  version = "50b8";

  src = fetchurl {
    url = "mirror://sourceforge/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-${version}.tar.gz";
    sha256 = "12fra2fdwqj6ilv9wdkc33rkj343rdcf5jyff4yiwywlrwaa2l1p";
  };

  patches = [
    ./fix-build.patch
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/tinyfugue/raw/ce016e8fb60a51de7c9d0c45dad109b3809de048/f/tinyfigue-configure-c99.patch";
      hash = "sha256-Ge6545PCgcvnSgtDChqUQgf6b3BMjNveBAxQ8fAy8f4=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/tinyfugue/raw/ce016e8fb60a51de7c9d0c45dad109b3809de048/f/tf-50b8.pcre.patch";
      hash = "sha256-T0XiadrviyuvtZZKYG/kXHQSC7RZkLKQGHOMrnfyLVg=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/tinyfugue/raw/ce016e8fb60a51de7c9d0c45dad109b3809de048/f/tf-50b8-pcre2.patch";
      hash = "sha256-pTtCUwMBk+t4lK0Z1fKPKaQemdpEdVPe2NScpD8QBS8=";
    })
  ];

  postPatch = ''
    rm -rv src/pcre-2.08
  '';

  buildInputs = [
    ncurses
    pcre2
    zlib
    openssl
  ];

  env.NIX_CFLAGS_COMPILE = "-fcommon -Wno-incompatible-pointer-types -Wno-return-mismatch";

  meta = {
    homepage = "https://tinyfugue.sourceforge.net/";
    description = "Terminal UI, screen-oriented MUD client";
    mainProgram = "tf";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
