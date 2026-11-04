{
  buildPerlPackage,
  fetchurl,
  MooXTypesMooseLike,
  TestException,
  TestFatal,
  DataPerl,
  Moo,
}:
buildPerlPackage {
  pname = "MooX-HandlesVia";
  version = "0.001009";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/MooX-HandlesVia-0.001009.tar.gz";
    hash = "sha256-cWNT44iU7Lfo5MF7yVSD219ZACsDVBtUpywn8qjzbBI=";
  };
  buildInputs = [
    MooXTypesMooseLike
    TestException
    TestFatal
  ];
  propagatedBuildInputs = [
    DataPerl
    Moo
  ];
  meta = {
    description = "NativeTrait-like behavior for Moo";
  };
}
