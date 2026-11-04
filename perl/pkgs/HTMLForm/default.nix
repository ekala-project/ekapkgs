{
  buildPerlPackage,
  fetchurl,
  lib,
  TestWarnings,
  HTMLParser,
  URI,
}:
buildPerlPackage {
  pname = "HTML-Form";
  version = "6.13";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/HTML-Form-6.13.tar.gz";
    hash = "sha256-rlrQ9v5wsaOCeJ1eg6m2acxUHunUWeG/qJtDrgwBTN0=";
  };
  buildInputs = [ TestWarnings ];
  propagatedBuildInputs = [
    HTMLParser
    URI
  ];
  meta = {
    description = "Class that represents an HTML form element";
    homepage = "https://github.com/libwww-perl/HTML-Form";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
