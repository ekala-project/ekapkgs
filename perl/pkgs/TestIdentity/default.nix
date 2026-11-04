{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Identity";
  version = "0.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Identity-0.01.tar.gz";
    hash = "sha256-LwIFAJrtFSZoGCqvoWNXqx9HtMvAAeiYcbZzh++OXyM=";
  };
  meta = {
    description = "Assert the referential identity of a reference";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
