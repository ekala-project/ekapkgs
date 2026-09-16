{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "IO-Capture";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REYNOLDS/IO-Capture-0.05.tar.gz";
    hash = "sha256-wsFaJUynT7jFfSXXtsvK/3ejtPtWlUI/H4C7Qjq//qk=";
  };
  meta = {
    description = "Abstract Base Class to build modules to capture output";
  };
}
