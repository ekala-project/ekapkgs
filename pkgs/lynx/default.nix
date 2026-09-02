{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  pkg-config,
  ncurses,
  openssl,
  zlib,
  nukeReferences,
}:

stdenv.mkDerivation rec {
  pname = "lynx";
  version = "2.9.2";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/lynx/tarballs/lynx${version}.tar.bz2"
      "https://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2"
    ];
    hash = "sha256-c3S4mTbZkWaeEB9Ol/LJWSA24ejNqnuvwlmnerb7B84=";
  };

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  configureFlags = [
    "--enable-default-colors"
    "--enable-widec"
    "--enable-ipv6"
    "--with-ssl"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    nukeReferences
    pkg-config
  ];

  buildInputs = [
    ncurses
    openssl
    zlib
  ];

  postConfigure = ''
    make cfg_defs.h
    nuke-refs cfg_defs.h
  '';

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  meta = {
    description = "Text-mode web browser";
    homepage = "https://lynx.invisible-island.net/";
    mainProgram = "lynx";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
