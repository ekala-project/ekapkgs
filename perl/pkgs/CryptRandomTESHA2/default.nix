{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Crypt-Random-TESHA2";
  version = "0.01";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANAJ/Crypt-Random-TESHA2-0.01.tar.gz";
    hash = "sha256-oJErQsUr4XPaUo1VJ+QNlnMkvASseNn8LdyR/xb+ljM=";
  };

  meta = {
    description = "Random numbers using timer/schedule entropy, aka userspace voodoo entropy";
    homepage = "https://github.com/danaj/Crypt-Random-TESHA2";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
