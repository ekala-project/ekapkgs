{
  buildPerlPackage,
  fetchurl,
  lib,
  TestRequires,
}:
buildPerlPackage {
  pname = "Data-Section-Simple";
  version = "0.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Data-Section-Simple-0.07.tar.gz";
    hash = "sha256-CzA1/9uQmqH33ta2CPqdiUQhyCwJfVHnFxFw1nV5qcs=";
  };

  buildInputs = [ TestRequires ];

  meta = {
    description = "Read data from __DATA__";
    homepage = "https://github.com/miyagawa/Data-Section-Simple";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
