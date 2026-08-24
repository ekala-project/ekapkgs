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
  version = "3.49.23";
  pname = "httrack";

  src = fetchFromGitHub {
    owner = "xroche";
    repo = "httrack";
    tag = finalAttrs.version;
    hash = "sha256-VLGhp9SXOG4xvJQOKMcsNSrerVmyC1E7UmmARk1qmOA=";
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
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
})
