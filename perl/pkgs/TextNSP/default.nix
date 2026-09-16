{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-NSP";
  version = "1.31";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TP/TPEDERSE/Text-NSP-1.31.tar.gz";
    hash = "sha256-oBIBvrKWNrPkHs2ips9lIv0mVBa9bZlPrQL1n7Sc9ZU=";
  };
  meta = {
    description = "Extract collocations and Ngrams from text";
    license = lib.licenses.gpl2Plus;
  };
}
