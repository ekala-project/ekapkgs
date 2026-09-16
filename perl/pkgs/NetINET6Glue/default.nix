{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Net-INET6Glue";
  version = "0.604";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SU/SULLR/Net-INET6Glue-0.604.tar.gz";
    hash = "sha256-kMNjmPlQFBTMzaiynyOn908vK09VLhLevxYhjHNbuxc=";
  };
  meta = {
    description = "Make common modules IPv6 ready by hotpatching";
  };
}
