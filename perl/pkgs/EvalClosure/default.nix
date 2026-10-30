{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestRequires,
}:
buildPerlPackage {

  pname = "Eval-Closure";
  version = "0.14";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz";
    hash = "sha256-6glE8vXsmNiVvvbVA+bko3b+pjg6a8ZMdnDUb/IhjK0=";
  };
  buildInputs = [
    TestFatal
    TestRequires
  ];
  meta = {
    description = "Safely and cleanly create closures via string eval";
    homepage = "https://metacpan.org/release/Eval-Closure";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
