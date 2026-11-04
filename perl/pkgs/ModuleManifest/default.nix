{
  buildPerlPackage,
  fetchurl,
  TestException,
  TestWarn,
  ParamsUtil,
}:
buildPerlPackage {
  pname = "Module-Manifest";
  version = "1.09";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Module-Manifest-1.09.tar.gz";
    hash = "sha256-o5X4D/FeoOZv1sRThEtnh+1Kh1o82N+ffikoAlC9U5s=";
  };

  buildInputs = [
    TestException
    TestWarn
  ];

  propagatedBuildInputs = [ ParamsUtil ];

  meta = {
    description = "Parse and examine a Perl distribution MANIFEST file";
  };
}
