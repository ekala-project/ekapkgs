{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "MIME-Base32";
  version = "1.303";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz";
    hash = "sha256-qyH6mRMOM6Cv9s21lvZH5eVl0gfWNLou8Gvb71BCTpk=";
  };

  meta = {
    homepage = "https://metacpan.org/release/MIME-Base32";
    description = "Base32 encoder and decoder";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
