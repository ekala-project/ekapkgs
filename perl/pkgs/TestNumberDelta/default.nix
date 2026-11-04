{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Test-Number-Delta";
  version = "1.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Number-Delta-1.06.tar.gz";
    hash = "sha256-U1QwkZ5v32zlX/dumJKvzLo7fUFg20XzrEOw+S/80Ek=";
  };
  meta = {
    description = "Compare the difference between numbers against a given tolerance";
    homepage = "https://github.com/dagolden/Test-Number-Delta";
    license = lib.licenses.asl20;
  };
}
