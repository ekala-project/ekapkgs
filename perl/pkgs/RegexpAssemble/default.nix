{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Regexp-Assemble";
  version = "0.38";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Regexp-Assemble-0.38.tgz";
    hash = "sha256-oGvn+a4bc8m/1bZmKxQcDXBGnpwZu0QTpu5W+Cra5EI=";
  };

  meta = {
    description = "Assemble multiple Regular Expressions into a single RE";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
