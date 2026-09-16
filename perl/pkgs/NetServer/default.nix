{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Net-Server";
  version = "2.014";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RH/RHANDOM/Net-Server-2.014.tar.gz";
    hash = "sha256-NAa5ylpmKgB17tR/t43hMWtgHJT2Kg7jSlVE25uqNyA=";
  };
  doCheck = false;
  meta = {
    description = "Extensible Perl internet server";
  };
}
