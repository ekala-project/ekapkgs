{
  lib,
  stdenv,
  fetchurl,
  perl,
  makeWrapper,
  file,
  lsof,
  binutils-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "rkhunter";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/rkhunter/rkhunter-${version}.tar.gz";
    hash = "sha256-91CqPiL4ObY3oHNkdRDXqjrfdJbiHzyHW3o2jHHTdIc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    install -Dm755 files/rkhunter $out/bin/rkhunter
    install -Dm644 files/rkhunter.conf $out/etc/rkhunter.conf

    mkdir -p $out/lib/rkhunter/scripts
    cp -r files/scripts/* $out/lib/rkhunter/scripts/ 2>/dev/null || true

    mkdir -p $out/share/rkhunter/db
    cp -r files/development $out/share/rkhunter/ 2>/dev/null || true

    mkdir -p $out/share/man/man8
    install -Dm644 files/rkhunter.8 $out/share/man/man8/ 2>/dev/null || true

    wrapProgram $out/bin/rkhunter \
      --prefix PATH : ${
        lib.makeBinPath [
          perl
          file
          lsof
          binutils-unwrapped
        ]
      }

    runHook postInstall
  '';

  dontBuild = true;

  meta = {
    description = "Rootkit Hunter - scans for rootkits, backdoors, and local exploits";
    homepage = "https://rkhunter.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
