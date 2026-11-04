{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestFatal,
  SubExporterProgressive,
}:
buildPerlModule {
  pname = "Const-Fast";
  version = "0.014";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Const-Fast-0.014.tar.gz";
    hash = "sha256-+AWVOgjFeEahak2F17dmOYr698NsFGX8sd6gnl+jlNs=";
  };

  propagatedBuildInputs = [ SubExporterProgressive ];

  buildInputs = [
    ModuleBuildTiny
    TestFatal
  ];

  meta = {
    description = "Facility for creating read-only scalars, arrays, and hashes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
