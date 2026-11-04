{
  buildPerlModule,
  fetchurl,
  lib,
  URI,
}:
buildPerlModule {
  pname = "Text-WikiFormat";
  version = "0.81";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CY/CYCLES/Text-WikiFormat-0.81.tar.gz";
    hash = "sha256-5DzZla2RV6foOdmT7ntsTRhUlH5VfQltnVqvdFB/qzM=";
  };

  propagatedBuildInputs = [ URI ];

  meta = {
    description = "Module for translating Wiki formatted text into other formats";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
