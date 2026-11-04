{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestRequires,
  Moo,
  SubHandlesVia,
}:
buildPerlPackage {
  pname = "MooX-late";
  version = "0.100";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/MooX-late-0.100.tar.gz";
    hash = "sha256-KuWx49pavA5ABieOy8+o+nwiTqVSmmpoisuyKcCeal8=";
  };
  buildInputs = [
    TestFatal
    TestRequires
  ];
  propagatedBuildInputs = [
    Moo
    SubHandlesVia
  ];
  meta = {
    description = "Easily translate Moose code to Moo";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
