{
  fetchurl,
  lib,
  stdenv,
  libnsl,
}:

let
  vanillaVersion = "7.6.q";
  patchLevel = "33";
in
stdenv.mkDerivation rec {
  pname = "tcp-wrappers";
  version = "${vanillaVersion}-${patchLevel}";

  src = fetchurl {
    url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_${vanillaVersion}.orig.tar.gz";
    sha256 = "0p9ilj4v96q32klavx0phw9va21fjp8vpk11nbh6v2ppxnnxfhwm";
  };

  debian = fetchurl {
    url = "mirror://debian/pool/main/t/tcp-wrappers/tcp-wrappers_${version}.debian.tar.xz";
    hash = "sha256-Lykjyu4hKDS/DqQ8JAFhKDffHrbJ9W1gjBKNpdaNRew=";
  };

  prePatch = ''
    tar -xaf $debian
    patches="$(cat debian/patches/series | sed 's,^,debian/patches/,') $patches"

    substituteInPlace Makefile --replace STRINGS STRINGDEFS
    substituteInPlace debian/patches/13_shlib_weaksym --replace STRINGS STRINGDEFS
  '';

  patches = [ ./cdecls.patch ];

  buildInputs = [ libnsl ];

  makeFlags = [
    "REAL_DAEMON_DIR=$(out)/bin"
    "linux"
    "AR:=$(AR)"
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp -v safe_finger tcpd tcpdchk tcpdmatch try-from "$out/bin"

    mkdir -p "$out/lib"
    cp -v shared/lib*.so* "$out/lib"

    mkdir -p "$out/include"
    cp -v *.h "$out/include"

    for i in 3 5 8;
    do
      mkdir -p "$out/man/man$i"
      cp *.$i "$out/man/man$i" ;
    done
  '';

  meta = {
    description = "TCP Wrappers, a network logger, also known as TCPD or LOG_TCP";
    homepage = "ftp://ftp.porcupine.org/pub/security/index.html";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
