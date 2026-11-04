{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Sub-Identify";
  version = "0.14";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RG/RGARCIA/Sub-Identify-0.14.tar.gz";
    hash = "sha256-Bo0nIIZRTdHoQrakCxvtuv7mOQDlsIiQ72cAA53vrW8=";
  };

  preCheck = ''
    # Remove tests with hardcoded line numbers.
    rm t/04codelocation-pureperl.t
    rm t/04codelocation.t
  '';

  meta = {
    description = "Retrieve names of code references";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
