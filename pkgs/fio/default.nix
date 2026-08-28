{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  libaio,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fio";
  version = "3.42";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    tag = "fio-${finalAttrs.version}";
    hash = "sha256-v2A2mY0Lvoje632761urfR7h1KHVcGnVDaKOMjexqis=";
  };

  buildInputs = [
    zlib
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libaio;

  # ./configure does not support autoconf-style --build=/--host=.
  configurePlatforms = [ ];

  configureFlags = [
    "--disable-native"
  ];

  dontAddStaticConfigureFlags = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    description = "Flexible IO Tester - an IO benchmark tool";
    homepage = "https://git.kernel.dk/cgit/fio/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
