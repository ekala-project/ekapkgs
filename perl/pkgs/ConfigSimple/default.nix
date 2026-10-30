{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Config-Simple";
  version = "4.58";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHERZODR/Config-Simple-4.58.tar.gz";
    hash = "sha256-3ZmVcG8Pk4ShXM/+EWw7biL0K6LljY8k7QPEoOOG7bQ=";
  };
  meta = {
    description = "Simple configuration file class";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
