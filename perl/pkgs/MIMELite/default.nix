{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailDateFormat,
}:
buildPerlPackage {
  pname = "MIME-Lite";
  version = "3.033";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/MIME-Lite-3.033.tar.gz";
    hash = "sha256-eKJ58dLiQlUcNH75ehP8Z1dmYCy4TCqAxWlAD082i6s=";
  };
  propagatedBuildInputs = [ EmailDateFormat ];
  meta = {
    description = "Low-calorie MIME generator (DEPRECATED)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
