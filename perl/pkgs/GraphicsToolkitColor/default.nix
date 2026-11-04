{
  buildPerlPackage,
  fetchurl,
  TestWarn,
}:
buildPerlPackage {
  pname = "Graphics-Toolkit-Color";
  version = "1.71";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LI/LICHTKIND/Graphics-Toolkit-Color-1.71.tar.gz";
    hash = "sha256-NOiLb2hY9H2ZYQHxWC8esA23+G4Snl8dYb9/m922LvI=";
  };
  buildInputs = [ TestWarn ];
  meta = {
    description = "Color palette constructor";
  };
}
