{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANMetaCheck,
  DistCheckConflicts,
  ModuleImplementation,
  TestFatal,
  TestNeeds,
  TestRequires,
  ModuleRuntime,
}:
buildPerlPackage {

  pname = "Package-Stash";
  version = "0.40";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Package-Stash-0.40.tar.gz";
    hash = "sha256-WpcixtnLKe4TPl97CKU2J2KgtWM/9RcGQqWwaG6V4GY=";
  };
  buildInputs = [
    CPANMetaCheck
    TestFatal
    TestNeeds
    TestRequires
  ];
  propagatedBuildInputs = [
    DistCheckConflicts
    ModuleImplementation
  ];
  meta = {
    description = "Routines for manipulating stashes";
    homepage = "https://github.com/moose/Package-Stash";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "package-stash-conflicts";
  };

}
