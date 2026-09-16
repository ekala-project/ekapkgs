{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Encode-EUCJPASCII";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEZUMI/Encode-EUCJPASCII-0.03.tar.gz";
    hash = "sha256-+ZjTTVX9nILPkQeGoESNHt+mC/aOLCMGckymfGKd6GE=";
  };
  outputs = [ "out" ];
}
