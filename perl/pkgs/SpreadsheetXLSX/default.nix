{
  buildPerlPackage,
  fetchurl,
  TestNoWarnings,
  TestWarnings,
  ArchiveZip,
  SpreadsheetParseExcel,
}:
buildPerlPackage {
  pname = "Spreadsheet-XLSX";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AS/ASB/Spreadsheet-XLSX-0.17.tar.gz";
    hash = "sha256-M7d4knz/FjCQZbdOuMRpawNxZg0szf5FvkYFCSrO6XY=";
  };
  buildInputs = [
    TestNoWarnings
    TestWarnings
  ];
  propagatedBuildInputs = [
    ArchiveZip
    SpreadsheetParseExcel
  ];
  meta = {
    description = "Perl extension for reading MS Excel 2007 files";
  };
}
