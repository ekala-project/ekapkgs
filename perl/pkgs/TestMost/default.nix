{
  buildPerlPackage,
  fetchurl,
  ExceptionClass,
  TestDeep,
  TestDifferences,
  TestException,
  TestWarn,
}:
buildPerlPackage {
  pname = "Test-Most";
  version = "0.38";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/Test-Most-0.38.tar.gz";
    hash = "sha256-CJ64lPe6zkw3xjNODikOsgM47hAiOvDILL5ygceDgt8=";
  };
  propagatedBuildInputs = [ ExceptionClass ];
  buildInputs = [
    TestDeep
    TestDifferences
    TestException
    TestWarn
  ];
  meta = {
    description = "Most commonly needed test functions and features";
  };
}
