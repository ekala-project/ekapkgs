{
  buildPerlPackage,
  fetchurl,
  NumberCompare,
  TextGlob,
  TryTiny,
  Filepushd,
  PathTiny,
  TestDeep,
  TestFilename,
}:
buildPerlPackage {
  pname = "Path-Iterator-Rule";
  version = "1.015";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Path-Iterator-Rule-1.015.tar.gz";
    hash = "sha256-87Bixo4Hx29o3lvDOHfP6eB4tjUaYboWUOM+CfUeyyk=";
  };
  propagatedBuildInputs = [
    NumberCompare
    TextGlob
    TryTiny
  ];
  buildInputs = [
    Filepushd
    PathTiny
    TestDeep
    TestFilename
  ];
  meta = {
    description = "Iterative, recursive file finder";
  };
}
