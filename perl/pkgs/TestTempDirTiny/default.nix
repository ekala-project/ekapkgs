{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-TempDir-Tiny";
  version = "0.018";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-TempDir-Tiny-0.018.tar.gz";
    hash = "sha256-17eh/X/M4BaNRPuIdpGP6KmvSa4OuLCWJbZ7GNcfXoE=";
  };

  meta = {
    description = "Temporary directories that stick around when tests fail";
    homepage = "https://github.com/dagolden/Test-TempDir-Tiny";
    license = lib.licenses.asl20;
  };
}
