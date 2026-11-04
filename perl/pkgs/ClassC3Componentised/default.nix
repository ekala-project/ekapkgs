{
  buildPerlPackage,
  fetchurl,
  TestException,
  ClassC3,
  ClassInspector,
  MROCompat,
}:
buildPerlPackage {
  pname = "Class-C3-Componentised";
  version = "1.001002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Class-C3-Componentised-1.001002.tar.gz";
    hash = "sha256-MFGxRtwe/q6hqaLp5rF3MICZW4mKtYPxVWWNX8gLlpM=";
  };
  buildInputs = [ TestException ];
  propagatedBuildInputs = [
    ClassC3
    ClassInspector
    MROCompat
  ];
  meta = {
    description = "Load mix-ins or components to your C3-based class";
  };
}
