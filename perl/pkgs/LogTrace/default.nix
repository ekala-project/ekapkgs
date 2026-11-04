{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Log-Trace";
  version = "1.070";
  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BB/BBC/Log-Trace-1.070.tar.gz";
    hash = "sha256-nsuCWO8wwvJN7/SRckDQ/nMkLaWyGSQC95gVsJLtNuM=";
  };
  meta = {
    description = "Provides a unified approach to tracing";
    license = lib.licenses.gpl1Only;
  };
}
