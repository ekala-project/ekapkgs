{
  lib,
  stdenv,
  fetchurl,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arpwatch";
  version = "3.6";

  src = fetchurl {
    url = "https://ee.lbl.gov/downloads/arpwatch/arpwatch-${finalAttrs.version}.tar.gz";
    hash = "sha256-+GUp/lf9taL/VBO8E8JFBj+Zs790JCH9MTMnIXW+gVY=";
  };

  buildInputs = [ libpcap ];

  # arpwatch only needs to know the sendmail path for runtime; it doesn't
  # link against it. Point to a standard location to satisfy configure.
  configureFlags = [
    "--with-sendmail=/run/current-system/sw/bin/sendmail"
  ];

  # Fix implicit function declarations and missing headers with modern GCC
  env.NIX_CFLAGS_COMPILE = "-include time.h";

  # _getshort was removed from glibc; alias to ns_get16
  postPatch = ''
    sed -i '1i #define _getshort(p) ns_get16(p)' dns.c
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preInstall = ''
    mkdir -p $out/sbin $out/share/man/man8 $out/etc/rc.d
  '';

  meta = {
    description = "Ethernet/IP address pairing monitor";
    homepage = "https://ee.lbl.gov/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "arpwatch";
  };
})
