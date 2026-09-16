{
  buildPerlPackage,
  fetchurl,
  lib,
  TestLeakTrace,
  ModuleImplementation,
}:
buildPerlPackage {
  pname = "List-SomeUtils";
  version = "0.59";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/List-SomeUtils-0.59.tar.gz";
    hash = "sha256-+rMDcuTGe/WkYGLaONHQyHVief6tqGbrQ5+ilXGi3Hs=";
  };
  buildInputs = [ TestLeakTrace ];
  propagatedBuildInputs = [ ModuleImplementation ];
  meta = {
    description = "Provide the stuff missing in List::Util";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
