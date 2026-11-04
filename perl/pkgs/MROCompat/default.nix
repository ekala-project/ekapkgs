{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "MRO-Compat";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/MRO-Compat-0.15.tar.gz";
    hash = "sha256-DUU1+I5Dur2Eq2BIZiFfxNBDmL1Nt7IYUtSjGxwV72E=";
  };
  meta = {
    description = "Mro::* interface compatibility for Perls < 5.9.5";
    homepage = "https://metacpan.org/release/MRO-Compat";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
