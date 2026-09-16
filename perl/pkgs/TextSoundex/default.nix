{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Text-Soundex";
  version = "3.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Text-Soundex-3.05.tar.gz";
    hash = "sha256-9t1VtCgLJd6peCIYOYZDglYAdOHWkzOV+u4lEMLbYO0=";
  };
  meta = {
    description = "Implementation of the soundex algorithm";
  };
}
