{
  buildPerlPackage,
  fetchurl,
  lib,
  CryptRandomTESHA2,
}:
buildPerlPackage {
  pname = "Crypt-Random-Seed";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANAJ/Crypt-Random-Seed-0.03.tar.gz";
    hash = "sha256-WT2lS1IsCcwmu8wOTknByOaIpv0zsHJq+AHXIqXI0PE=";
  };
  propagatedBuildInputs = [ CryptRandomTESHA2 ];
  meta = {
    description = "Provide strong randomness for seeding";
    homepage = "https://github.com/danaj/Crypt-Random-Seed";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
