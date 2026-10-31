{
  buildPerlPackage,
  fetchurl,
  OLEStorage_Lite,
  ParseRecDescent,
}:
buildPerlPackage {
  pname = "Spreadsheet-WriteExcel";
  version = "2.40";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMCNAMARA/Spreadsheet-WriteExcel-2.40.tar.gz";
    hash = "sha256-41aq1oZs8TVzEmjuDpeaGXRDwVoEh46c8+gNAirWwH4=";
  };
  propagatedBuildInputs = [
    OLEStorage_Lite
    ParseRecDescent
  ];
  meta = {
    description = "Write to a cross platform Excel binary file";
  };
}
