{
  buildPerlPackage,
  fetchurl,
  TestWarn,
  ClassAccessor,
  ClassDataInheritable,
  CryptSysRandom,
  LWP,
}:
buildPerlPackage {
  pname = "Net-OAuth";
  version = "0.33";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RR/RRWO/Net-OAuth-0.33.tar.gz";
    hash = "sha256-BqKQwTvBycKs7jOnkImzLzBHlkkl1OqZLrbBzD2N9sE=";
  };

  buildInputs = [ TestWarn ];

  propagatedBuildInputs = [
    ClassAccessor
    ClassDataInheritable
    CryptSysRandom
    LWP
  ];

  meta = {
    description = "Implementation of the OAuth protocol";
  };
}
