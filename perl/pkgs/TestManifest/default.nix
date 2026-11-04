{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Manifest";
  version = "2.023";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BD/BDFOY/Test-Manifest-2.023.tar.gz";
    hash = "sha256-0k5SVT58uc2oH5L/6MkrPkNGcY5HEIAaWzW38lGnceI=";
  };

  meta = {
    description = "Interact with a t/test_manifest file";
    homepage = "https://github.com/briandfoy/test-manifest";
    license = lib.licenses.artistic2;
  };
}
