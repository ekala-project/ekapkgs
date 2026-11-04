{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassTiny,
  SubExporter,
  namespaceclean,
  TestWarnings,
}:
buildPerlPackage {
  pname = "Devel-PartialDump";
  version = "0.20";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Devel-PartialDump-0.20.tar.gz";
    hash = "sha256-rvD/PqWalpGWfCiFEY/2ZxVghJVwicQ4j0nbZG/T2Qc=";
  };
  propagatedBuildInputs = [
    ClassTiny
    SubExporter
    namespaceclean
  ];
  buildInputs = [
    TestWarnings
  ];
  meta = {
    description = "Partial dumping of data structures, optimized for argument printing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
