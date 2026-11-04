{
  buildPerlPackage,
  fetchurl,
  CarpAssert,
  TestException,
}:
buildPerlPackage {
  pname = "Carp-Assert-More";
  version = "2.3.0";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/Carp-Assert-More-2.3.0.tar.gz";
    hash = "sha256-/2nqCb2maiAPygiK3ZHFww5lcqt7ujF6f58zxRKzzqc=";
  };
  propagatedBuildInputs = [ CarpAssert ];
  buildInputs = [ TestException ];
  meta = {
    description = "Convenience assertions for common situations";
  };
}
