{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "String-Escape";
  version = "2010.002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EV/EVO/String-Escape-2010.002.tar.gz";
    hash = "sha256-/WRfizNiJNIKha5/saOEV26sMp963DkjwyQego47moo=";
  };
  meta = {
    description = "Backslash escapes, quoted phrase, word elision, etc";
  };
}
