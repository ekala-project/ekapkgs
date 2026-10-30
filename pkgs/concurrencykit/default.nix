{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "concurrencykit";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "concurrencykit";
    repo = "ck";
    tag = finalAttrs.version;
    hash = "sha256-lxJ8WsZ3pBGf4sFYj5+tR37EYDZqpksaoohiIKA4pRI=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures";
    homepage = "http://concurrencykit.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
  };
})
