{
  buildPerlPackage,
  fetchurl,
  lib,
  TextUnidecode,
}:
buildPerlPackage {
  pname = "Email-MIME-ContentType";
  version = "1.028";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-ContentType-1.028.tar.gz";
    hash = "sha256-55UCRkM/ftbD5P1N8iJ+DyNBE3w8qxmJAY/DcPWBRcQ=";
  };
  propagatedBuildInputs = [ TextUnidecode ];
  meta = {
    description = "Parse and build a MIME Content-Type or Content-Disposition Header";
    homepage = "https://github.com/rjbs/Email-MIME-ContentType";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
