{
  buildPerlPackage,
  fetchurl,
  lib,
  DataDump,
  ModuleCPANfile,
  ModuleFind,
  RegexpTrie,
  URIcpan,
  ExtUtilsMakeMakerCPANfile,
  ParseDistname,
  TestFailWarnings,
  TestUseAllModules,
}:
buildPerlPackage {
  pname = "Perl-PrereqScanner-NotQuiteLite";
  version = "0.9917";

  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Perl-PrereqScanner-NotQuiteLite-0.9917.tar.gz";
    hash = "sha256-O6fuF9lfDJqNkqLkwYVLZKcH0cAihGIm3Q36Qvfeud0=";
  };

  propagatedBuildInputs = [
    DataDump
    ModuleCPANfile
    ModuleFind
    RegexpTrie
    URIcpan
  ];

  buildInputs = [
    ExtUtilsMakeMakerCPANfile
    ParseDistname
    TestFailWarnings
    TestUseAllModules
  ];

  meta = {
    description = "Tool to scan your Perl code for its prerequisites";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "scan-perl-prereqs-nqlite";
  };
}
