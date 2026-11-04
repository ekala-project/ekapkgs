{
  buildPerlPackage,
  fetchurl,
  ScopeGuard,
  IPCSystemSimple,
  TestFatal,
}:
buildPerlPackage {
  pname = "autobox";
  version = "3.0.1";

  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHOCOLATE/autobox-v3.0.1.tar.gz";
    hash = "sha256-wwO3/M+qH/TUxCmrPxXlyip3VU74yfw7jGK6hZ6HTJg=";
  };

  propagatedBuildInputs = [ ScopeGuard ];

  buildInputs = [
    IPCSystemSimple
    TestFatal
  ];

  meta = {
    description = "Call methods on native types";
  };
}
