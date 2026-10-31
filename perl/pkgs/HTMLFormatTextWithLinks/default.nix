{
  buildPerlModule,
  fetchurl,
  lib,
  HTMLFormatter,
}:
buildPerlModule {
  pname = "HTML-FormatText-WithLinks";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/ST/STRUAN/HTML-FormatText-WithLinks-0.15.tar.gz";
    hash = "sha256-f8wat561j7l9Q+W90U4heRolCiBJmJGMYtahcRMYM7E=";
  };
  propagatedBuildInputs = [ HTMLFormatter ];
  meta = {
    description = "HTML to text conversion with links as footnotes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
