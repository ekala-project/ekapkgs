{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "Variable-Magic";
  version = "0.64";
  src = fetchurl {
    url = "mirror://cpan/authors/id/V/VP/VPIT/Variable-Magic-0.64.tar.gz";
    hash = "sha256-n3hTJJyeo7TfkvtreQwDpgaA/AKfRMi/mJTczwGVFr0=";
  };
  meta = {
    description = "Associate user-defined magic to variables from Perl";
    homepage = "https://search.cpan.org/dist/Variable-Magic";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
