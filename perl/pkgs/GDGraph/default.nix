{
  buildPerlPackage,
  fetchurl,
  lib,
  GDText,
  CaptureTiny,
  TestException,
}:
buildPerlPackage {
  pname = "GDGraph";
  version = "1.56";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/GDGraph-1.56.tar.gz";
    hash = "sha256-b0nMTlkBVIDbnJtrGK/YxQvjCIZoe2lBFRPQbziXERM=";
  };

  propagatedBuildInputs = [ GDText ];

  buildInputs = [
    CaptureTiny
    TestException
  ];

  meta = {
    description = "Graph Plotting Module for Perl 5";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
