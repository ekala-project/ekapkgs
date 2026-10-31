{
  buildPerlModule,
  fetchurl,
  lib,
  DateTimeFormatMail,
  DateTimeFormatW3CDTF,
  XMLParser,
}:
buildPerlModule {
  pname = "XML-RSS";
  version = "1.62";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-RSS-1.62.tar.gz";
    hash = "sha256-0ycGNELH/3FDmTqgwtFv3lEhSRyXFmHrbLcA0uBDi04=";
  };
  propagatedBuildInputs = [
    DateTimeFormatMail
    DateTimeFormatW3CDTF
    XMLParser
  ];
  meta = {
    description = "Creates and updates RSS files";
    homepage = "https://metacpan.org/release/XML-RSS";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
