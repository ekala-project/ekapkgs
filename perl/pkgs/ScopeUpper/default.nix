{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Scope-Upper";
  version = "0.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VP/VPIT/Scope-Upper-0.34.tar.gz";
    hash = "sha256-WB2LxRDevQxFal/HlSy3E4rmZ78486d+ltdz3DGWpB4=";
  };
  meta = {
    description = "Act on upper scopes";
    homepage = "https://search.cpan.org/dist/Scope-Upper";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
