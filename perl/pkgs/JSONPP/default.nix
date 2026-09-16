{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "JSON-PP";
  version = "4.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/JSON-PP-4.16.tar.gz";
    hash = "sha256-i8LxYrr8QmRcSJkFrXJUDw08KEs2DJYpkJUYPDDMl4k=";
  };
  meta = {
    description = "JSON::XS compatible pure-Perl module";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "json_pp";
  };
}
