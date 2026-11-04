{
  buildPerlPackage,
  fetchurl,
  lib,
  Moose,
  aliased,
  namespaceautoclean,
}:
buildPerlPackage {
  pname = "MooseX-Role-WithOverloading";
  version = "0.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/MooseX-Role-WithOverloading-0.17.tar.gz";
    hash = "sha256-krCV1z8SIPnC7S06qlugcutaot4gm3xFXaWocBuYaGU=";
  };
  propagatedBuildInputs = [
    Moose
    aliased
    namespaceautoclean
  ];
  meta = {
    description = "(DEPRECATED) Roles which support overloading";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
