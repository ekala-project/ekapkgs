{
  buildPerlPackage,
  fetchurl,
  lib,
  unzip,
}:
buildPerlPackage {
  pname = "Hook-LexWrap";
  version = "0.26";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Hook-LexWrap-0.26.tar.gz";
    hash = "sha256-tgvcX5j5T5KUsGre+CsdmW2hktXxg/n0NLYQ/RE37C0=";
  };

  buildInputs = [ unzip ];

  meta = {
    description = "Lexically scoped subroutine wrappers";
    homepage = "https://github.com/karenetheridge/Hook-LexWrap";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
