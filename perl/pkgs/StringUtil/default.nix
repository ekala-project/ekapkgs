{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "String-Util";
  version = "1.36";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BA/BAKERSCOT/String-Util-1.36.tar.gz";
    hash = "sha256-UXsasyVm/U1ei+I9mTOc47/+4pEsX/KfXclYcP9Pyw4=";
  };
  meta = {
    description = "String processing utility functions";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
