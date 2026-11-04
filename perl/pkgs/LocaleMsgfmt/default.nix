{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Locale-Msgfmt";
  version = "0.15";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AZ/AZAWAWI/Locale-Msgfmt-0.15.tar.gz";
    hash = "sha256-wydoMcvuz1i+AggbzBgL00jao12iGnc3t7A4pZ9kOrQ=";
  };

  meta = {
    description = "Compile .po files to .mo files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
