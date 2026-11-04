{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Class-Accessor-Lite";
  version = "0.08";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZUHO/Class-Accessor-Lite-0.08.tar.gz";
    hash = "sha256-dbO47I7+aHZ3tj8KEO75ZuAfYHNcVmVs51y7RMq6M1o=";
  };

  meta = {
    description = "Minimalistic variant of Class::Accessor";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
