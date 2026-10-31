{
  buildPerlPackage,
  fetchurl,
  lib,
  FileWhich,
  JSONMaybeXS,
  CaptureTiny,
  TestDifferences,
}:
buildPerlPackage {
  pname = "Devel-NYTProf";
  version = "6.12";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JK/JKEENAN/Devel-NYTProf-6.12.tar.gz";
    hash = "sha256-qDtZheTalr24X1McFqtvPUkHGnM80JSqMPqF+2pLAsQ=";
  };
  propagatedBuildInputs = [
    FileWhich
    JSONMaybeXS
  ];
  buildInputs = [
    CaptureTiny
    TestDifferences
  ];
  meta = {
    description = "Powerful fast feature-rich Perl source code profiler";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
