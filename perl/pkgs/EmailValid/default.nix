{
  buildPerlPackage,
  fetchurl,
  lib,
  IOCaptureOutput,
  MailTools,
  NetDNS,
  NetDomainTLD,
}:
buildPerlPackage {
  pname = "Email-Valid";
  version = "1.203";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Valid-1.203.tar.gz";
    hash = "sha256-ICG/ux4sJ55evYRoDllvlzRNQphQsjIme3b0kDdSK5M=";
  };
  propagatedBuildInputs = [
    IOCaptureOutput
    MailTools
    NetDNS
    NetDomainTLD
  ];
  meta = {
    description = "Check validity of Internet email addresses";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
