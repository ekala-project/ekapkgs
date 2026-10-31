{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDeep,
  TestFailWarnings,
  TestFatal,
}:
buildPerlPackage {
  pname = "Hash-Ordered";
  version = "0.014";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Hash-Ordered-0.014.tar.gz";
    hash = "sha256-jcNs15FVrjerij3l/ZEg/7qaMeQJJYwoUp7FJRxZdHs=";
  };
  buildInputs = [
    TestDeep
    TestFailWarnings
    TestFatal
  ];
  meta = {
    description = "Fast, pure-Perl ordered hash class";
    homepage = "https://github.com/dagolden/Hash-Ordered";
    license = lib.licenses.asl20;
  };
}
