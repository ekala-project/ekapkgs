{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "CDDB_get";
  version = "2.28";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FO/FONKIE/CDDB_get-2.28.tar.gz";
    hash = "sha256-vcy6H6jkwc8xicXlo1KaZpOmSKpSgrWXU4x6rdzm2ck=";
  };

  meta = {
    description = "Get the CDDB info for an audio cd";
    license = lib.licenses.artistic1;
    mainProgram = "cddb.pl";
  };
}
