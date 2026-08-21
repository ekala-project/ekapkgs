{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  zlib,
  bzip2,
  xz,
  libpcap,
  wandio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtrace";
  version = "4.0.32-2";

  src = fetchFromGitHub {
    owner = "LibtraceTeam";
    repo = "libtrace";
    tag = finalAttrs.version;
    hash = "sha256-cqRhTNSXvNlZW63baxqcqVJJEVe8SeunTPdJ623kIvo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];
  buildInputs = [
    zlib
    bzip2
    xz
    libpcap
    wandio
  ];

  meta = {
    description = "C Library for working with network packet traces";
    homepage = "https://github.com/LibtraceTeam/libtrace";
    changelog = "https://github.com/LibtraceTeam/libtrace/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
