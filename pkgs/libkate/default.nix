{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  bison,
  flex,
  libogg,
  libpng,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkate";
  version = "0.4.3";

  src = fetchFromGitLab {
    domain = "gitlab.xiph.org/";
    owner = "xiph";
    repo = "kate";
    tag = "kate-${finalAttrs.version}";
    hash = "sha256-HwDahmjDC+O321Ba7MnHoQdHOFUMpFzaNdLHQeEg11Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    libogg
    libpng
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Library for encoding and decoding Kate streams";
    homepage = "https://wiki.xiph.org/index.php/OggKate";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
  };
})
