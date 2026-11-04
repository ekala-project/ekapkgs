{
  buildPerlModule,
  fetchurl,
  lib,
  TestRequires,
}:
buildPerlModule {
  pname = "Cwd-Guard";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Cwd-Guard-0.05.tar.gz";
    hash = "sha256-evx8orlQLkQCQZOK2Xo+fr1VAYDr1hQuHbOUGGsmjnc=";
  };
  buildInputs = [ TestRequires ];
  meta = {
    description = "Temporary changing working directory (chdir)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
