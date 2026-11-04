{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Locale-Maketext-Lexicon";
  version = "1.00";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DRTECH/Locale-Maketext-Lexicon-1.00.tar.gz";
    hash = "sha256-tz9rBKWNPw446/IRWkwVMvGk7vb6xcaipEnk4Uwd3Hw=";
  };

  meta = {
    description = "Use other catalog formats in Maketext";
    homepage = "https://search.cpan.org/dist/Locale-Maketext-Lexicon";
    license = lib.licenses.mit;
    mainProgram = "xgettext.pl";
  };
}
