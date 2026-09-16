{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLTagset,
  HTTPMessage,
}:
buildPerlPackage {
  pname = "HTML-Parser";
  version = "3.85";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OA/OALDERS/HTML-Parser-3.85.tar.gz";
    hash = "sha256-/UK6ar4HJBzwrVe+JGw5gAZfaD5EZeWbRq+e/ryODHE=";
  };
  propagatedBuildInputs = [
    HTMLTagset
    HTTPMessage
  ];
  meta = {
    description = "HTML parser class";
    homepage = "https://github.com/libwww-perl/HTML-Parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
