{
  lib,
  stdenv,
  fetchurl,
  libxcrypt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysvinit";
  version = "3.04";

  src = fetchurl {
    url = "mirror://savannah/sysvinit/sysvinit-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-KmIf5uRSi8kTCLdIZ92q6733dT8COVwMW66Be9K346U=";
  };

  prePatch = ''
    # Patch some minimal hard references, so halt/shutdown work
    sed -i -e "s,/sbin/,$out/sbin/," src/halt.c src/init.c src/paths.h
  '';

  buildInputs = [ libxcrypt ];

  makeFlags = [
    "SULOGINLIBS=-lcrypt"
    "ROOT=$(out)"
    "MANDIR=/share/man"
  ];

  preInstall = ''
    substituteInPlace src/Makefile --replace /usr /
  '';

  postInstall = ''
    mv $out/sbin/killall5 $out/bin
    ln -sf killall5 $out/bin/pidof
  '';

  meta = {
    homepage = "https://www.nongnu.org/sysvinit/";
    description = "Utilities related to booting and shutdown";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
