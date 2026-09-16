{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "List-MoreUtils-XS";
  version = "0.430";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-XS-0.430.tar.gz";
    hash = "sha256-6M5G1XwXnuzYdYKT6UAP8wCq8g/v4KnRW5/iMCucskI=";
  };
  meta = {
    description = "Provide the stuff missing in List::Util in XS";
    license = lib.licenses.asl20;
  };
}
