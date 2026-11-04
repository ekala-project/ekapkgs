{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Email-Date-Format";
  version = "1.008";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Date-Format-1.008.tar.gz";
    hash = "sha256-Qyt8g/+IdJrxKAA/UlfFc67BpGNBjbkO0ihDy7wli08=";
  };

  meta = {
    description = "Produce RFC 2822 date strings";
    homepage = "https://github.com/rjbs/Email-Date-Format";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
