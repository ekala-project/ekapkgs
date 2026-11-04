{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
}:
buildPerlModule {
  pname = "aliased";
  version = "0.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/aliased-0.34.tar.gz";
    hash = "sha256-w1BSRQfNgn+rhk5dTCzDULG6uqEvqVrsDKAIQ/zH3us=";
  };
  buildInputs = [ ModuleBuildTiny ];
  meta = {
    description = "Use shorter versions of class names";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
