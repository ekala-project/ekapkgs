{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "IO-SessionData";
  version = "1.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PH/PHRED/IO-SessionData-1.03.tar.gz";
    hash = "sha256-ZKRxKj7bs/0QIw2ylsKcjGbwZq37wMPfakglj+85Ld0=";
  };
  outputs = [
    "out"
    "dev"
  ];
  meta = {
    description = "Supporting module for SOAP::Lite";
  };
}
