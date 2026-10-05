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
  version = "3.43";

  src = fetchFromGitHub {
    owner = "axboe";
    repo = "fio";
    tag = "fio-${finalAttrs.version}";
    hash = "sha256-5/3Q4ObLIxL2EukxGzujrN6n7kagjI8WYZYDkmYH4cE=";
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
