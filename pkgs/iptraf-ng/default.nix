{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "iptraf-ng";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "iptraf-ng";
    repo = "iptraf-ng";
    rev = "v${version}";
    sha256 = "sha256-SM1cJYNnZlGl3eWaYd8DlPrV4AL9nck1tjdOn0CHVUw=";
  };

  buildInputs = [ ncurses ];

  makeFlags = [
    "DESTDIR=$(out)"
    "prefix=/usr"
    "sbindir=/bin"
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "Console-based network monitoring utility (fork of iptraf)";
    homepage = "https://github.com/iptraf-ng/iptraf-ng";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "iptraf-ng";
  };
}
