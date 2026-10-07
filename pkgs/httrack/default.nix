{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  openssl,
  libiconv,
  autoreconfHook,
  autoconf-archive,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.50.5";
  pname = "httrack";

  src = fetchFromGitHub {
    owner = "xroche";
    repo = "httrack";
    tag = finalAttrs.version;
    hash = "sha256-vS1LgKw+TWGsr1rjmZDRtb+vE63jrlwvkTZSgx8tCGc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [
    libiconv
    openssl
    zlib
  ];

  meta = {
    description = "Easy-to-use offline browser / website mirroring utility";
    homepage = "https://www.httrack.com";
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
  };
})
