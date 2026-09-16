{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Cpanel-JSON-XS";
  version = "4.42";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RU/RURBAN/Cpanel-JSON-XS-4.42.tar.gz";
    hash = "sha256-4awvqx46bS2ZjTRAxgAGc2W9x9vwyPKyBZy85LTIMXM=";
  };
  meta = {
    description = "CPanel fork of JSON::XS, fast and correct serializing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "cpanel_json_xs";
  };
}
