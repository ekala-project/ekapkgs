{
  buildPerlPackage,
  fetchurl,
  lib,
  TestNoWarnings,
}:
buildPerlPackage {
  pname = "Math-Random-ISAAC";
  version = "1.004";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JA/JAWNSY/Math-Random-ISAAC-1.004.tar.gz";
    hash = "sha256-J3PwL78gfpdF52oDffCL9ajMmH7SPFcEDOf3sVYfK3w=";
  };

  buildInputs = [ TestNoWarnings ];

  meta = {
    description = "Perl interface to the ISAAC PRNG algorithm";
    homepage = "https://search.cpan.org/dist/Math-Random-ISAAC";
    license = with lib.licenses; [
      publicDomain
      mit
      artistic2
      gpl1Plus
    ];
  };
}
