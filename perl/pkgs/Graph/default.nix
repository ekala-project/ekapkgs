{
  buildPerlPackage,
  fetchurl,
  lib,
  HeapFibonacci,
  SetObject,
}:
buildPerlPackage {
  pname = "Graph";
  version = "0.9727";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETJ/Graph-0.9727.tar.gz";
    hash = "sha256-OSqJFtyVExq+jJE9/Kx2mEhL9IZrQq9fcEPABi50Iik=";
  };
  propagatedBuildInputs = [
    HeapFibonacci
    SetObject
  ];
  meta = {
    description = "GRaph data structures and algorithms";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
