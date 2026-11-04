{
  buildPerlPackage,
  fetchurl,
  lib,
  XMLParser,
}:
buildPerlPackage {

  pname = "XML-Twig";
  version = "3.52";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIROD/XML-Twig-3.52.tar.gz";
    hash = "sha256-/vdYJsJPK4d9Cg0mRSEvxPuXVu1NJxFhSsFcSX6GgK0=";
  };
  postInstall = ''
    mkdir -p $out/bin
    cp tools/xml_grep/xml_grep $out/bin
  '';
  propagatedBuildInputs = [ XMLParser ];
  doCheck = false; # requires lots of extra packages
  meta = {
    description = "Perl module for processing huge XML documents in tree mode";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "xml_grep";
  };

}
