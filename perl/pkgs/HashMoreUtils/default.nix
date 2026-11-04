{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Hash-MoreUtils";
  version = "0.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REHSACK/Hash-MoreUtils-0.06.tar.gz";
    hash = "sha256-25qPuGfVB1PDgIiaXlQHVlG14IybO3IctyIMCINUfeg=";
  };

  meta = {
    description = "Provide the stuff missing in Hash::Util";
    homepage = "https://metacpan.org/release/Hash-MoreUtils";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
