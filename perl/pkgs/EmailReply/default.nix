{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailAbstract,
  EmailAddress,
  EmailMIME,
}:
buildPerlPackage {
  pname = "Email-Reply";
  version = "1.204";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Reply-1.204.tar.gz";
    hash = "sha256-uk/YCsUBfW0TLgNYx4aw7NHHrcvu5cGfs9opZHkaVvA=";
  };

  propagatedBuildInputs = [
    EmailAbstract
    EmailAddress
    EmailMIME
  ];

  meta = {
    description = "Reply to an email message";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
