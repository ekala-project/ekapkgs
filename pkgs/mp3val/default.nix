{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mp3val";
  version = "0.1.8";

  src = fetchurl {
    url = "mirror://sourceforge/mp3val/mp3val-${finalAttrs.version}-src.tar.gz";
    sha256 = "17y3646ghr38r620vkrxin3dksxqig5yb3nn4cfv6arm7kz6x8cm";
  };

  makefile = "Makefile.linux";

  installPhase = ''
    install -Dv mp3val "$out/bin/mp3val"
  '';

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Tool for validating and repairing MPEG audio streams";
    homepage = "https://mp3val.sourceforge.net/index.shtml";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    mainProgram = "mp3val";
  };
})
