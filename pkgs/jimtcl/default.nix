{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  asciidoc,
  tcl,
  sqlite,
  readline,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jimtcl";
  version = "0.84";

  src = fetchFromGitHub {
    owner = "msteveb";
    repo = "jimtcl";
    rev = finalAttrs.version;
    sha256 = "sha256-MvsC82PMmh7PP1sXNwZRNDNFU7r5LWRA6YqvuvZ9yZE=";
  };

  nativeBuildInputs = [
    pkg-config
    asciidoc
    tcl
  ];

  buildInputs = [
    sqlite
    readline
    openssl
  ];

  configureFlags = [
    "--shared"
    "--with-ext=oo"
    "--with-ext=tree"
    "--with-ext=binary"
    "--with-ext=sqlite3"
    "--with-ext=readline"
    "--with-ext=json"
    "--enable-utf8"
    "--ipv6"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Open source small-footprint implementation of the Tcl programming language";
    homepage = "http://jim.tcl.tk/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    mainProgram = "jimsh";
  };
})
