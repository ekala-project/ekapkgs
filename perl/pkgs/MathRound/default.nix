{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-Round";
  version = "0.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GR/GROMMEL/Math-Round-0.07.tar.gz";
    hash = "sha256-c6cymoblSlwppEA4LlgDCVtY8zEp5hod8Ak7SCTekyc=";
  };

  meta = {
    description = "Perl extension for rounding numbers";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
