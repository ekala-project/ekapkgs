{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vde2";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "virtualsquare";
    repo = "vde-2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yf6QB7j5lYld2XtqhYspK4037lTtimoFc7nCavCP+mU=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  buildInputs = [
    openssl
    python3
  ];

  meta = {
    description = "Virtual Distributed Ethernet";
    homepage = "https://github.com/virtualsquare/vde-2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
