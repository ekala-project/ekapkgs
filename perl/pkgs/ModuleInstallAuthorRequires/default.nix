{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleInstall,
}:
buildPerlPackage {
  pname = "Module-Install-AuthorRequires";
  version = "0.02";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/Module-Install-AuthorRequires-0.02.tar.gz";
    hash = "sha256-zGMhU310XSqDqChvhe8zRnRZOcw7NBAgRb7IVg6PTOw=";
  };

  propagatedBuildInputs = [ ModuleInstall ];

  meta = {
    description = "Declare author-only dependencies";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
