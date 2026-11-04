{
  buildPerlPackage,
  fetchurl,
  lib,
  DataUUID,
  SubExporter,
}:
buildPerlPackage {
  pname = "Data-GUID";
  version = "0.051";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Data-GUID-0.051.tar.gz";
    hash = "sha256-aOp3xz/KiROC8gbhJEkJRQG2+/Llf1SQLVBkInz9ji4=";
  };

  propagatedBuildInputs = [
    DataUUID
    SubExporter
  ];

  meta = {
    description = "Globally unique identifiers";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
