{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLTree,
}:
buildPerlPackage {
  pname = "HTML-Element-Extended";
  version = "1.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSISK/HTML-Element-Extended-1.18.tar.gz";
    hash = "sha256-8+8a8Qjyf+8V6+xmR58lHOCKpJvQCwRiycgMhrS2sys=";
  };
  propagatedBuildInputs = [ HTMLTree ];
  meta = {
    description = "Perl extension for HTML::Element(3)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
