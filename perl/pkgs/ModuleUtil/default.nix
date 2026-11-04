{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Module-Util";
  version = "1.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MATTLAW/Module-Util-1.09.tar.gz";
    hash = "sha256-bPvLakUGREbsiqDuGn3dxCC1RGkwM0QYeu+E0sfz4sY=";
  };

  meta = {
    description = "Module name tools and transformations";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "pm_which";
  };
}
