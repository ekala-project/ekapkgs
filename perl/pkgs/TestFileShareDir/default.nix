{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  ClassTiny,
  FileCopyRecursive,
  FileShareDir,
  PathTiny,
  ScopeGuard,
}:
buildPerlPackage {
  pname = "Test-File-ShareDir";
  version = "1.001002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KE/KENTNL/Test-File-ShareDir-1.001002.tar.gz";
    hash = "sha256-szZHy7Sy8vz73k+LtDg9CslcL4nExXcOtpHxZDozeq0=";
  };
  buildInputs = [ TestFatal ];
  propagatedBuildInputs = [
    ClassTiny
    FileCopyRecursive
    FileShareDir
    PathTiny
    ScopeGuard
  ];
  meta = {
    description = "Create a Fake ShareDir for your modules for testing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
