{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Business-ISBN-Data";
  version = "20231006.001";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Business-ISBN-Data-20231006.001.tar.gz";
    hash = "sha256-KhazbjIzXOjI337m8ig2LzSuc8T8wSNQCVCiyMd/F0g=";
  };
  meta = {
    description = "Data pack for Business::ISBN";
    license = lib.licenses.artistic2;
  };
}
