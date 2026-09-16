{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Time-Period";
  version = "1.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PB/PBOYD/Time-Period-1.25.tar.gz";
    hash = "sha256-0H+lgFKb6sapyCdMa/IgtMOq3mhd9lwWadUzOb9u8eg=";
  };
  meta = {
    description = "Perl module to deal with time periods";
  };
}
