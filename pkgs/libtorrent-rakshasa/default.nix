{
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rakshasa";
  version = "0.16.13";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PRVSH2kOzQhmUSdueDSB9stLwCtbITisuvpysrw4M+I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cppunit
    curl
    openssl
    zlib
  ];

  configureFlags = [ "--enable-aligned=yes" ];

  enableParallelBuilding = true;

  meta = {
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    homepage = "https://github.com/rakshasa/libtorrent";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
