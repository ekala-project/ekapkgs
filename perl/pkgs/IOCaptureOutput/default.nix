{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-CaptureOutput";
  version = "1.1105";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/IO-CaptureOutput-1.1105.tar.gz";
    hash = "sha256-rpkAn8oSc4APFp7LgvTtHMbHZ5XxVr7lwAkwBdVy9Ic=";
  };

  meta = {
    description = "(DEPRECATED) capture STDOUT and STDERR from Perl code, subprocesses or XS";
    homepage = "https://github.com/dagolden/IO-CaptureOutput";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
