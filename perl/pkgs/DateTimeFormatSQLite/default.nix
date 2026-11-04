{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTimeFormatBuilder,
}:
buildPerlPackage {
  pname = "DateTime-Format-SQLite";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CF/CFAERBER/DateTime-Format-SQLite-0.11.tar.gz";
    hash = "sha256-zB9OCuHTmw1MPd3M/XQjx3xnpwlQxLXsq/jKVTqylLQ=";
  };

  propagatedBuildInputs = [ DateTimeFormatBuilder ];

  meta = {
    description = "Parse and format SQLite dates and times";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
