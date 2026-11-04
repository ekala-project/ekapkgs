{
  buildPerlPackage,
  fetchurl,
  DevelStackTrace,
}:
buildPerlPackage {
  pname = "Class-ReturnValue";
  version = "0.55";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JE/JESSE/Class-ReturnValue-0.55.tar.gz";
    hash = "sha256-7Tg2iF149zTM16mFUOxCKmFt98MTEMG3sfZFn1+w5L0=";
  };
  propagatedBuildInputs = [ DevelStackTrace ];
  meta = {
    description = "(deprecated) polymorphic return values";
  };
}
