{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Object";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-Object-0.08.tar.gz";
    hash = "sha256-ZSeJZBR4NzE/QQjlW1lnboo2TW7fAbPcGYruiUqx0Ls=";
  };

  meta = {
    description = "Thoroughly testing objects via registered handlers";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
