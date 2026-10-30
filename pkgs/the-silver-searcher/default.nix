{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  pcre2,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "silver-searcher-ng";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "silver-searcher";
    repo = "silver-searcher-ng";
    tag = finalAttrs.version;
    hash = "sha256-IiVFbS9XGmqcGN4NRXFC07cV6bGKDs9C2y5XxJKdvFk=";
  };

  patches = [ ./bash-completion.patch ];

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    NIX_LDFLAGS = "-lgcc_s";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    pcre2
    zlib
    xz
  ];

  meta = {
    description = "Code-searching tool similar to ack, but faster";
    homepage = "https://github.com/silver-searcher/silver-searcher-ng";
    license = lib.licenses.asl20;
    mainProgram = "ag";
    platforms = lib.platforms.all;
  };
})
