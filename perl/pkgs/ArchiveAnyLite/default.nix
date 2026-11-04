{
  buildPerlPackage,
  fetchurl,
  lib,
  ArchiveZip,
  ExtUtilsMakeMakerCPANfile,
  TestUseAllModules,
}:
buildPerlPackage {
  pname = "Archive-Any-Lite";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Archive-Any-Lite-0.11.tar.gz";
    hash = "sha256-FcGIJTmTpLZuVZnweJsTJvCmbAkr2/rJMTcG1BwoUXA=";
  };

  propagatedBuildInputs = [ ArchiveZip ];

  buildInputs = [
    ExtUtilsMakeMakerCPANfile
    TestUseAllModules
  ];

  meta = {
    description = "Simple CPAN package extractor";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
