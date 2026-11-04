{
  buildPerlModule,
  fetchurl,
  lib,
  PodParser,
}:
buildPerlModule {
  pname = "Pod-LaTeX";
  version = "0.61";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TJ/TJENNESS/Pod-LaTeX-0.61.tar.gz";
    hash = "sha256-FahA6hyKds08hl+78v7DOwNhXA2qUPnIAMVODPBlnUY=";
  };
  propagatedBuildInputs = [ PodParser ];
  meta = {
    description = "Convert Pod data to formatted Latex";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
