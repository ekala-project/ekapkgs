{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Mail-Sender";
  version = "0.903";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/Mail-Sender-0.903.tar.gz";
    hash = "sha256-RBPrSfUgqDGBUYEcywWo1UKXOq2iCqUDrTL5/8mKOb8=";
  };
  meta = {
    description = "(DEPRECATED) module for sending mails with attachments through an SMTP server";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
