{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "XML-RegExp";
  version = "0.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TJ/TJMATHER/XML-RegExp-0.04.tar.gz";
    hash = "sha256-3xmQCWA2CFyOLUWQT+GA+Cv+1A8afgUkPzNOoQCQ/FQ=";
  };

  meta = {
    description = "Regular expressions for XML tokens";
    license = lib.licenses.gpl2Plus;
  };
}
