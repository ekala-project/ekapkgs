{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Email-Address-XS";
  version = "1.05";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PA/PALI/Email-Address-XS-1.05.tar.gz";
    hash = "sha256-FRC38Q1nIBA3zVDSLJ1rJu7KVe3tpM20a7yiflmk6hY=";
  };

  meta = {
    description = "Parse and format RFC 5322 email addresses and groups";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
