{
  buildPerlModule,
  fetchurl,
  lib,
  ClassMix,
}:
buildPerlModule {
  pname = "Crypt-Eksblowfish";
  version = "0.009";
  src = fetchurl {
    url = "mirror://cpan/authors/id/Z/ZE/ZEFRAM/Crypt-Eksblowfish-0.009.tar.gz";
    hash = "sha256-PMcSbVhBEHI3qb4txcf7wWfPPEtM40Z4qESLhQdXAUw=";
  };
  propagatedBuildInputs = [ ClassMix ];
  meta = {
    description = "Eksblowfish block cipher";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
