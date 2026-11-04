{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLParser,
}:
buildPerlPackage {
  pname = "libxml-perl";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KM/KMACLEOD/libxml-perl-0.08.tar.gz";
    hash = "sha256-RXEFm3tdSLfOUrATieldeYv1zyAgUjwVP/J7SYFTycs=";
  };

  propagatedBuildInputs = [ XMLParser ];

  meta = {
    description = "Collection of Perl modules for working with XML";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
