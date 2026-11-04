{
  buildPerlPackage,
  fetchurl,
  lib,
  ArchiveAnyLite,
  ArrayDiff,
  ClassAccessor,
  DataBinary,
  FileFindObject,
  ModuleFind,
  ParseDistname,
  PerlPrereqScannerNotQuiteLite,
  SoftwareLicense,
  ExtUtilsMakeMakerCPANfile,
  TestFailWarnings,
}:
buildPerlPackage {
  pname = "Module-CPANTS-Analyse";
  version = "1.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Module-CPANTS-Analyse-1.02.tar.gz";
    hash = "sha256-nhFzm5zQi6LXWllzfx+yl/RYA/KJBjxcdZv8eP1Rbns=";
  };
  # Fails with 'symlinks not listed in MANIFEST is not ignored for a non-local distribution'
  postPatch = ''
    rm -f t/analyse/manifest.t
  '';
  propagatedBuildInputs = [
    ArchiveAnyLite
    ArrayDiff
    ClassAccessor
    DataBinary
    FileFindObject
    ModuleFind
    ParseDistname
    PerlPrereqScannerNotQuiteLite
    SoftwareLicense
  ];
  buildInputs = [
    ExtUtilsMakeMakerCPANfile
    TestFailWarnings
  ];
  meta = {
    description = "Generate Kwalitee ratings for a distribution";
    homepage = "https://cpants.cpanauthors.org";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
