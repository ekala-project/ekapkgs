{
  buildPerlPackage,
  fetchurl,
  Moo,
  TestFatal,
  MooXTypesMooseLike,
}:
buildPerlPackage {
  pname = "MooX-Types-MooseLike-Numeric";
  version = "1.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MATEU/MooX-Types-MooseLike-Numeric-1.03.tar.gz";
    hash = "sha256-Fq3rYXuWPQEBeZIsLk6HYt93x1Iy4XMgtFmGjElwxEs=";
  };
  buildInputs = [
    Moo
    TestFatal
  ];
  propagatedBuildInputs = [ MooXTypesMooseLike ];
  meta = {
    description = "Moo types for numbers";
  };
}
