{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "statserial";
  version = "1.1";

  src = fetchurl {
    url = "https://www.ibiblio.org/pub/Linux/system/serial/statserial-${finalAttrs.version}.tar.gz";
    sha256 = "0rrrmxfba5yn836zlgmr8g9xnrpash7cjs7lk2m44ac50vakpks0";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-lcurses' '-lncurses'

    substituteInPlace Makefile \
      --replace 'LDFLAGS = -s -N' '#LDFLAGS = -s -N'
  '';

  buildInputs = [
    ncurses
    glibc
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp statserial $out/bin

    mkdir -p $out/share/man/man1
    cp statserial.1 $out/share/man/man1
  '';

  meta = {
    homepage = "https://sites.google.com/site/tranter/software";
    description = "Display serial port modem status lines";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "statserial";
  };
})
