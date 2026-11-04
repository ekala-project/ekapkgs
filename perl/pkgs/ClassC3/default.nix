{
  buildPerlPackage,
  fetchurl,
  lib,
  AlgorithmC3,
}:
buildPerlPackage {
  pname = "Class-C3";
  version = "0.35";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Class-C3-0.35.tar.gz";
    hash = "sha256-hAU88aaPzIwSBWwvEgrfBPf2jjvjT0QI6V0Cb+5n4z4=";
  };

  propagatedBuildInputs = [ AlgorithmC3 ];

  meta = {
    description = "Pragma to use the C3 method resolution order algorithm";
    homepage = "https://metacpan.org/release/Class-C3";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
