{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "safecopy";
  version = "1.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/safecopy/safecopy/safecopy-${finalAttrs.version}/safecopy-${finalAttrs.version}.tar.gz";
    sha256 = "1zf4kk9r8za9pn4hzy1y3j02vrhl1rxfk5adyfq0w0k48xfyvys2";
  };

  meta = {
    description = "Data recovery tool for damaged hardware";
    homepage = "https://safecopy.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "safecopy";
  };
})
