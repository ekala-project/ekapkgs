{
  buildPerlPackage,
  fetchurl,
  lib,
  HTMLElementExtended,
}:
buildPerlPackage {
  pname = "HTML-TableExtract";
  version = "2.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSISK/HTML-TableExtract-2.15.tar.gz";
    hash = "sha256-hsWcnVjaPKF02l5i9aD7AvTaArGx4B355dFLtl5MPs8=";
  };
  preCheck = ''
    rm t/30_tree.t
  '';
  propagatedBuildInputs = [ HTMLElementExtended ];
  meta = {
    description = "Perl module for extracting the content contained in tables within an HTML document, either as text or encoded element trees";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
