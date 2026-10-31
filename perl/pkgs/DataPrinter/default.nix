{
  buildPerlPackage,
  fetchurl,
  lib,
  ClonePP,
  FileHomeDir,
  PackageStash,
  SortNaturally,
}:
buildPerlPackage {
  pname = "Data-Printer";
  version = "1.001001";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GARU/Data-Printer-1.001001.tar.gz";
    hash = "sha256-q64DMVUU0rcxxkYrjwZ2SN2ZChA1SyFgbHeM/ZHUe4A=";
  };
  propagatedBuildInputs = [
    ClonePP
    FileHomeDir
    PackageStash
    SortNaturally
  ];
  meta = {
    description = "Colored & full-featured pretty print of Perl data structures and objects";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
