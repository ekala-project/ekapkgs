{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleInstall,
}:
buildPerlPackage {

  pname = "Module-Install-AuthorTests";
  version = "0.002";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Module-Install-AuthorTests-0.002.tar.gz";
    hash = "sha256-QCVyLeY1ft9TwoUBsA59qSzS+fxhG6B1N2Gg4d/zLYg=";
  };
  propagatedBuildInputs = [ ModuleInstall ];
  meta = {
    description = "Designate tests only run by module authors";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
