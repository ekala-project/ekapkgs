{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Ref-Util";
  version = "0.204";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARC/Ref-Util-0.204.tar.gz";
    hash = "sha256-QV+nPbrPRPPV15wUiIzJlFYnIKtGjm9x+RzR92nxBeE=";
  };

  meta = {
    description = "Utility functions for checking references";
    license = lib.licenses.mit;
  };
}
