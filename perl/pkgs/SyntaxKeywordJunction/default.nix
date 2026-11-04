{
  buildPerlPackage,
  fetchurl,
  lib,
  syntax,
  TestRequires,
}:
buildPerlPackage {
  pname = "Syntax-Keyword-Junction";
  version = "0.003008";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FR/FREW/Syntax-Keyword-Junction-0.003008.tar.gz";
    hash = "sha256-i0l18hsZkqfmwt9dzJKyVMYZJVle3c368LFJhxeqle8=";
  };

  buildInputs = [ TestRequires ];

  propagatedBuildInputs = [ syntax ];

  meta = {
    description = "Perl6 style Junction operators in Perl5";
    homepage = "https://github.com/frioux/Syntax-Keyword-Junction";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
