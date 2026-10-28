{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  ncurses,
  sqlite,
  zlib,
  lua,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stone-soup";
  version = "0.32.1";

  src = fetchFromGitHub {
    owner = "crawl";
    repo = "crawl";
    tag = "${finalAttrs.version}";
    hash = "sha256-IBOjWpW1lEPwapyPB7WuzgZjfd97yK1VNc0m5r1Wvg0=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
    python3.pkgs.setuptools
    which
  ];

  buildInputs = [
    ncurses
    sqlite
    zlib
    lua.v5_1
  ];

  preBuild = ''
    cd crawl-ref/source
  '';

  makeFlags = [
    "prefix=$(out)"
    "DATADIR=$(out)/share/crawl"
    "SAVEDIR=~/.crawl"
    "NO_PKGCONFIG="
    "BUILD_PCRE="
    "LUA_PACKAGE=lua5.1"
  ];

  buildFlags = [ "install" ];

  dontInstall = true;

  meta = {
    description = "Dungeon Crawl Stone Soup roguelike game";
    homepage = "https://crawl.develz.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "crawl";
  };
})
