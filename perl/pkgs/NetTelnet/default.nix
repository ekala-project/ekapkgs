{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Net-Telnet";
  version = "3.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JR/JROGERS/Net-Telnet-3.05.tar.gz";
    hash = "sha256-Z39ouizSqCT64yP6guGDv349A8PEmckdkjvWKDeWp0M=";
  };
  meta = {
    description = "Interact with TELNET port or other TCP ports";
  };
}
