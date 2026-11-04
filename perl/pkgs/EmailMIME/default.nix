{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailAddressXS,
  EmailMIMEContentType,
  EmailMIMEEncodings,
  EmailMessageID,
  EmailSimple,
  MIMETypes,
  ModuleRuntime,
}:
buildPerlPackage {
  pname = "Email-MIME";
  version = "1.953";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MIME-1.953.tar.gz";
    hash = "sha256-mPsGeFBpmiJLq8NI8c7+MNdExg2okC56XOnYt+c99zU=";
  };
  propagatedBuildInputs = [
    EmailAddressXS
    EmailMIMEContentType
    EmailMIMEEncodings
    EmailMessageID
    EmailSimple
    MIMETypes
    ModuleRuntime
  ];
  meta = {
    description = "Easy MIME message handling";
    homepage = "https://github.com/rjbs/Email-MIME";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
