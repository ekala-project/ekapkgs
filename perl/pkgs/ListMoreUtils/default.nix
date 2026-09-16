{
  buildPerlPackage,
  fetchurl,
  ExporterTiny,
  ListMoreUtilsXS,
  TestLeakTrace,
}:
buildPerlPackage {
  pname = "List-MoreUtils";
  version = "0.430";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REHSACK/List-MoreUtils-0.430.tar.gz";
    hash = "sha256-Y7H3hCzULZtTjR404DMN5f8VWeTCc3NCUGQYJ29kZSc=";
  };
  propagatedBuildInputs = [
    ExporterTiny
    ListMoreUtilsXS
  ];
  buildInputs = [ TestLeakTrace ];
}
