{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  perl,
  pkg-config,
  readline,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "augeas";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "hercules-team";
    repo = "augeas";
    tag = "release-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FH+i/6nnhbp2j+45eNT63LzI/uY5KvLYePivyaO1odM=";
  };

  patches = [
    ./bootstrap.diff
  ];

  postPatch = ''
    ./bootstrap --gnulib-srcdir=.gnulib
  '';

  configureFlags = lib.optionals stdenv.buildPlatform.isDarwin [ "--disable-gnulib-tests" ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
  ];

  buildInputs = [
    readline
    libxml2
  ];

  enableParallelBuilding = false;

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Configuration editing tool";
    license = lib.licenses.lgpl21Only;
    homepage = "https://augeas.net/";
    changelog = "https://github.com/hercules-team/augeas/releases/tag/release-${finalAttrs.version}";
    mainProgram = "augtool";
    platforms = lib.platforms.unix;
  };
})
