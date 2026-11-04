{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Term-ReadPassword";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PH/PHOENIX/Term-ReadPassword-0.11.tar.gz";
    hash = "sha256-4ahmNFs1+f/vfQA34T1tTLKAMQCJ+YwgcTiAvHD7QyM=";
  };

  outputs = [ "out" ];

  meta = {
    description = "This module lets you ask the user for a password in the traditional way, from the keyboard, without echoing";
  };
}
