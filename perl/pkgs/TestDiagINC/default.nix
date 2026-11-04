{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
}:
buildPerlPackage {
  pname = "Test-DiagINC";
  version = "0.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-DiagINC-0.010.tar.gz";
    hash = "sha256-W8uNNWxQnjWdU9hpwH79qo/uXWz5mJcBi5qRTOshIi4=";
  };
  buildInputs = [ CaptureTiny ];
  meta = {
    description = "List modules and versions loaded if tests fail";
    license = lib.licenses.asl20;
  };
}
