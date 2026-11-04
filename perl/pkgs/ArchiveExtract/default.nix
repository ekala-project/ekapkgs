{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Archive-Extract";
  version = "0.88";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Archive-Extract-0.88.tar.gz";
    hash = "sha256-z/zxNc0GIih9OwIVT31nFklUSfyu0DlmYhlI4l6l90I=";
  };

  meta = {
    description = "Generic archive extracting mechanism";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
