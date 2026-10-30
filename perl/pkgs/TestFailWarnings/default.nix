{
  buildPerlPackage,
  fetchurl,
  lib,
  CaptureTiny,
}:
buildPerlPackage {

  pname = "Test-FailWarnings";
  version = "0.008";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-FailWarnings-0.008.tar.gz";
    hash = "sha256-2jTvkCn2hJ1gJiAdSRJ9BU7mrEuXnIIhAxX1chlkqW8=";
  };
  buildInputs = [ CaptureTiny ];
  meta = {
    description = "Add test failures if warnings are caught";
    homepage = "https://github.com/dagolden/Test-FailWarnings";
    license = lib.licenses.asl20;
  };

}
