{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailAddress,
  JSON,
}:
buildPerlPackage {
  pname = "Email-Address-List";
  version = "0.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BP/BPS/Email-Address-List-0.06.tar.gz";
    hash = "sha256-MFuUx3gBHO5w2fIVFNkumF+p3Mu4TGR5jwwfCyTrhw4=";
  };

  buildInputs = [ JSON ];

  propagatedBuildInputs = [ EmailAddress ];

  meta = {
    description = "RFC close address list parsing";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
