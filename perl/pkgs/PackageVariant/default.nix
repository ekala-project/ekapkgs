{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  ImportInto,
  strictures,
}:
buildPerlPackage {
  pname = "Package-Variant";
  version = "1.003002";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSTROUT/Package-Variant-1.003002.tar.gz";
    hash = "sha256-su2EnS9M3WZGdRLao/FDJm1t+BDF+ukXWyUsV7wVNtw=";
  };

  buildInputs = [ TestFatal ];

  propagatedBuildInputs = [
    ImportInto
    strictures
  ];

  meta = {
    description = "Parameterizable packages";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
