{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Email-MessageID";
  version = "1.408";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-MessageID-1.408.tar.gz";
    hash = "sha256-Hz1bT/Cxx7OemsfDGPs3rc0LrJVWA2VGSU0U8G3FZDw=";
  };
  meta = {
    description = "Generate world unique message-ids";
    homepage = "https://github.com/rjbs/Email-MessageID";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
