{
  buildPerlPackage,
  fetchurl,
  lib,
  gfortran,
  FileWhich,
}:
buildPerlPackage {
  pname = "ExtUtils-F77";
  version = "1.26";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETJ/ExtUtils-F77-1.26.tar.gz";
    hash = "sha256-q90dPuxMpPyuXxUrQLyqhi48gG4H5KqRI3V/aqSLndY=";
  };

  buildInputs = [ gfortran ];

  propagatedBuildInputs = [ FileWhich ];

  meta = {
    description = "Simple interface to F77 libs";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
