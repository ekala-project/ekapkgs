{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Template-Tiny";
  version = "1.14";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Template-Tiny-1.14.tar.gz";
    hash = "sha256-gZz6tgREg8/ijOsof938MXaiAlsbbw6YCy3MJtImm0w=";
  };
  meta = {
    description = "Template Toolkit reimplemented in as little code as possible";
    homepage = "https://github.com/karenetheridge/Template-Tiny";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
