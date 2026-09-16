{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "common-sense";
  version = "3.75";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/common-sense-3.75.tar.gz";
    hash = "sha256-qGocTKTzAG10eQZEJaCfpbZonlcmH8uZT+Z9Bhy6Dn4=";
  };
  meta = {
    description = "Implements some sane defaults for Perl programs";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
