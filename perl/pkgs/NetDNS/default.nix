{
  buildPerlPackage,
  fetchurl,
  lib,
  DigestHMAC,
}:
buildPerlPackage {
  pname = "Net-DNS";
  version = "1.56";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NL/NLNETLABS/Net-DNS-1.56.tar.gz";
    hash = "sha256-WTDjn3aJWzgMfKEfwINS0VrXHEH+hMEt+2oyLRf2aUY=";
  };
  propagatedBuildInputs = [ DigestHMAC ];
  makeMakerFlags = [ "--noonline-tests" ];
  meta = {
    description = "Perl Interface to the Domain Name System";
    license = lib.licenses.mit;
  };
}
