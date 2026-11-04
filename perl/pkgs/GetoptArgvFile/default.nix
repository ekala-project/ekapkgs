{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Getopt-ArgvFile";
  version = "1.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JS/JSTENZEL/Getopt-ArgvFile-1.11.tar.gz";
    hash = "sha256-NwmqUTzm/XHRpVoC400vCQAX1TUKm9RHAFZTybCDWyI=";
  };

  meta = {
    description = "Interpolates script options from files into @ARGV or another array";
    license = lib.licenses.artistic1;
  };
}
