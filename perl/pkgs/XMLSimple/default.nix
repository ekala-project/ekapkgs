{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLSAXExpat,
}:
buildPerlPackage {
  pname = "XML-Simple";
  version = "2.25";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GRANTM/XML-Simple-2.25.tar.gz";
    hash = "sha256-Ux/drr6iQWdD61xP36sCj1AhI9miIEBaQQDmj8SA2/g=";
  };

  propagatedBuildInputs = [ XMLSAXExpat ];

  meta = {
    description = "API for simple XML files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
