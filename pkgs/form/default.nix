{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  zstd,
  mpfr,
  zlib,
  flint,
}:
let
  zstd_src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    # latest commit on dev (only branch that has that folder) that changed zlibWrapper (https://github.com/facebook/zstd/commits/dev/zlibWrapper)
    rev = "0b96e6d42a9b22eb472a050fcd2cc4be3ffb8e2b";
    hash = "sha256-EPsLRjCCj0ruQ+z7eBzr/ACF0wh5LzUmdpbw/w5moWU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "form";
  version = "5.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "form-dev";
    repo = "form";
    tag = "v${finalAttrs.version}";
    hash = "sha256-luV6yHhm7BHbNRd1VQp7UGIA289KikYQGNXAFMEXnvs=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gmp
    mpfr
    zstd
    zlib
    flint
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/extern/zstd
    cp -r ${zstd_src}/zlibWrapper $sourceRoot/extern/zstd/
    chmod -R +w $sourceRoot
  '';

  meta = {
    description = "Symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
