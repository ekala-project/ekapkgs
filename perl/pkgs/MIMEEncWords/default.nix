{
  buildPerlPackage,
  fetchurl,
  lib,
  MIMECharset,
}:
buildPerlPackage {
  pname = "MIME-EncWords";
  version = "1.014.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-EncWords-1.014.3.tar.gz";
    hash = "sha256-6a+1SGEdTn5sULfwa70rG7KAjjeoEN7vtTfGevVIUjg=";
  };

  propagatedBuildInputs = [ MIMECharset ];

  meta = {
    description = "Deal with RFC 2047 encoded words (improved)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
