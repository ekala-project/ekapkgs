{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Error";
  version = "0.17030";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Error-0.17030.tar.gz";
    hash = "sha256-NNOCJ2wPsNazg1W5TJajCxLYNNVmLrU/CI7iXj5xKSQ=";
  };
  meta = {
    description = "Error/exception handling in an OO-ish way";
  };
}
