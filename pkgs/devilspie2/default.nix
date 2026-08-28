{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
  pkg-config,
  glib,
  gtk3,
  lua,
  libwnck,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "devilspie2";
  version = "0.45";

  src = fetchFromGitHub {
    owner = "dsalt";
    repo = "devilspie2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3TLA4vvTY8nt2LupLH8btdGhz7mfWYHnwRf7lQKGq8A=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    lua
    libwnck
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp bin/devilspie2 $out/bin
    cp devilspie2.1 $out/share/man/man1
  '';

  meta = {
    description = "Window matching utility";
    homepage = "https://www.nongnu.org/devilspie2/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "devilspie2";
  };
})
