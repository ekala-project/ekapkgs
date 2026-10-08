{
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  installShellFiles,
  lib,
  libtool,
  libtorrent-rakshasa,
  lua,
  ncurses,
  openssl,
  pkg-config,
  stdenv,
  writableTmpDirAsHomeHook,
  withLua ? false,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rtorrent";
  version = "0.16.24";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "rtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hkd6MtPn0Np96KAhO9psuGMLo1yEcp73b1xg7gwaLwY=";
  };

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    cppunit
    curl
    libtool
    libtorrent-rakshasa
    ncurses
    openssl
    zlib
  ]
  ++ lib.optionals withLua [ lua.v5_4_compat ];

  configureFlags = [
    "--with-xmlrpc-tinyxml2"
    "--with-posix-fallocate"
  ]
  ++ lib.optionals withLua [ "--with-lua" ];

  postInstall = ''
    installManPage doc/old/rtorrent.1
    install -Dm644 doc/rtorrent.rc-example -t $out/share/doc/rtorrent/rtorrent.rc
  '';

  passthru = {
    inherit libtorrent-rakshasa;
  };

  meta = {
    description = "Ncurses client for libtorrent, ideal for use with screen, tmux, or dtach";
    homepage = "https://rakshasa.github.io/rtorrent/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "rtorrent";
    platforms = lib.platforms.unix;
  };
})
