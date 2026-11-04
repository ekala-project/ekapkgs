{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-utf8";
  version = "1.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKF/Test-utf8-1.02.tar.gz";
    hash = "sha256-34LwnFlAgwslpJ8cgWL6JNNx5gKIDt742aTUv9Zri9c=";
  };
  meta = {
    description = "Handy utf8 tests";
    homepage = "https://github.com/2shortplanks/Test-utf8";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
