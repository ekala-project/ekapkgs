{
  buildPerlPackage,
  fetchurl,
  lib,
  CryptURandom,
  DigestHMAC,
}:
buildPerlPackage {

  pname = "Authen-SASL";
  version = "2.2100";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EH/EHUELS/Authen-SASL-2.2100.tar.gz";
    hash = "sha256-Tw8QCu7TS1KXepS335c+fwuPktFnsJ8rJJurgehZDlc=";
  };
  propagatedBuildInputs = [
    CryptURandom
    DigestHMAC
  ];
  meta = {
    description = "SASL Authentication framework";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
