{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Crypt-Blowfish";
  version = "2.14";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DP/DPARIS/Crypt-Blowfish-2.14.tar.gz";
    hash = "sha256-RrNDH/tr9bnLNZ95Vl1IQH5lKtKwT99cpipp5xl6Z7E=";
  };
  meta = {
    description = "Perl Blowfish encryption module";
    license = lib.licenses.bsdOriginalShortened;
  };
}
