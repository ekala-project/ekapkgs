{
  buildPerlPackage,
  fetchurl,
  TestDeep,
  TestWarn,
}:
buildPerlPackage {
  pname = "YAML-PP";
  version = "0.38.0";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TI/TINITA/YAML-PP-v0.38.0.tar.gz";
    hash = "sha256-qBlGXFL2o0EEmjlCdCwI4E8olLKmZILkOn9AfOELTqA=";
  };
  buildInputs = [
    TestDeep
    TestWarn
  ];
  meta = {
    description = "YAML 1.2 Processor";
  };
}
