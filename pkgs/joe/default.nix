{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "joe";
  version = "4.6";

  src = fetchurl {
    url = "mirror://sourceforge/joe-editor/${pname}-${version}.tar.gz";
    sha256 = "1pmr598xxxm9j9dl93kq4dv36zyw0q2dh6d7x07hf134y9hhlnj9";
  };

  meta = {
    description = "Full featured terminal-based screen editor";
    homepage = "https://joe-editor.sourceforge.io";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
