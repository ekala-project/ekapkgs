{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Class-Loader";
  version = "2.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VI/VIPUL/Class-Loader-2.03.tar.gz";
    hash = "sha256-T+8gdurWBCNFT/H06ChZqam5lCtfuO7gyYucY8nyuOc=";
  };

  meta = {
    description = "Load modules and create objects on demand";
  };
}
