{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Sys-Mmap";
  version = "0.20";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TODDR/Sys-Mmap-0.20.tar.gz";
    hash = "sha256-GCDOLInxq3NXZE+NsPSfFC9UUmJQ+x4jXbEKqA8V4s8=";
  };

  meta = {
    description = "Use mmap to map in a file as a Perl variable";
  };
}
