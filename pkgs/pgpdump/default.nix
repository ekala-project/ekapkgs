{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  bzip2,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pgpdump";
  version = "0.37";

  src = fetchFromGitHub {
    owner = "kazu-yamamoto";
    repo = "pgpdump";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nB7f6VTxRidymi9RV7W1x9JbWi9Eoa/CYzYmekYDVOo=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    zlib
    bzip2
  ];

  meta = {
    description = "PGP packet visualizer";
    mainProgram = "pgpdump";
    homepage = "http://www.mew.org/~kazu/proj/pgpdump/en/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
})
