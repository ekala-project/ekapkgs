{
  buildPerlPackage,
  fetchurl,
  lib,
  pango,
  Cairo,
  Glib,
}:
buildPerlPackage {
  pname = "Pango";
  version = "1.227";
  src = fetchurl {
    url = "mirror://cpan/authors/id/X/XA/XAOC/Pango-1.227.tar.gz";
    hash = "sha256-NLCkIt8/7NdZdYcEhVJFfUiudkxDu+/SqdYs62yLrHE=";
  };
  buildInputs = [ pango ];
  propagatedBuildInputs = [
    Cairo
    Glib
  ];
  meta = {
    description = "Layout and render international text";
    homepage = "https://gtk2-perl.sourceforge.net";
    license = lib.licenses.lgpl21Plus;
  };
}
