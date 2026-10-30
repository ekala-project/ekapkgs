{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailDateFormat,
}:
buildPerlPackage {

  pname = "Email-Simple";
  version = "2.218";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Simple-2.218.tar.gz";
    hash = "sha256-Lc4daP3pnVPbnKQ+IRtpsWm6Lvrs+HpVyzOpM2BHyW0=";
  };
  propagatedBuildInputs = [ EmailDateFormat ];
  meta = {
    description = "Simple parsing of RFC2822 message format and headers";
    homepage = "https://github.com/rjbs/Email-Simple";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
